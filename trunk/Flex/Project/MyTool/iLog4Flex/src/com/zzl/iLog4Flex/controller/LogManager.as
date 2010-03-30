/**
* iLog4Flex
* 
* iLog4Flex is flex runtime log component. A log windows can be loaded at runtime of flex application.
* 
* Author:	Zunlin Zhang
* Data:		2009-04-19
* Version:	Alpha 1.0s
*/

package com.zzl.iLog4Flex.controller
{
	import com.zzl.iLog4Flex.model.LogFilterSetting;
	import com.zzl.iLog4Flex.model.LogLevel;
	import com.zzl.iLog4Flex.model.LogSetting;
	import com.zzl.iLog4Flex.model.LogStruct;
	import com.zzl.iLog4Flex.view.LogWnd;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	
	[Event(name="com.zzl.iLog4Flex.LogUpdate", type="flash.events.Event")]
	
	/**
	 * LogManager is the main entry of using iLog4Flex. You can access all settings and log information through this class.
	 * You also need import Logger class for log item support.
	 * 
	 * Use:
	 * 		getLogger(class_name) for getting a new logger for a special class.
	 * 			After go you get the logger class, you should be responsible for destroy it after the relating class is destroied.
	 * 		showLog() for showing a log windows at runtime.
	 *  
	 * @author larryzzl
	 * 
	 */	
	public class LogManager extends EventDispatcher
	{
		public static const EVENT_LOG_UPDATE:String = "com.zzl.iLog4Flex.LogUpdate";

		private static var _inst:LogManager;
		private static var _logID:int = 0;
				
		private var _logHistory:ArrayCollection = new ArrayCollection;
		private var _classNames:ArrayCollection = new ArrayCollection;
		private var _setting:LogSetting = LogSetting.inst;

		public function LogManager(val:LogManagerIniter){}
		
		public static function get inst():LogManager
		{
			if (_inst == null)
			{
				_inst = new LogManager(new LogManagerIniter);
				_inst.Init();
			}
			return _inst;
		}
		
		/** 
		 * @private
		 */		
		private function Init():void
		{
			_classNames.addItem("All");
			_setting.addEventListener(LogSetting.EVENT_LOG_SETTING_UPDATE, OnLogSettingUpdate, false, 0, true);
		}
		
		/**
		 * Function showLog will add a log windows to your main application container. In that shows all the logs you are having now.
		 */		
		public function showLog():void
		{
			LogWnd.show();
		}
		
		/**
		 * Setter useDebugMode means showing the DEBUG level of log or not.
		 *  
		 * @param val show(true) or not show(false).
		 */		
		public function set useDebugMode(val:Boolean):void
		{
			_setting.useDebugMode = val;
		}
		
		/**
		 * Setter showTrace means trace out the log together with iLog4Flex or not.
		 *  
		 * @param val trace(true) or not trace(false).
		 */
		public function set showTrace(val:Boolean):void
		{
			_setting.showTrace = val;
		}
		
		/**
		 * Setter maxLogLines can set the max number count of loges. So you can decide how many loges you want to keep in memory.
		 *  
		 * @param val max lines number.
		 * @default 2000.
		 */
		public function set maxLogLines(val:int):void
		{
			_setting.maxLogLines = val;
		}
		
		/**
		 * Function getLogger returns a logger relating to a special class name.
		 * 
		 * @param className the name of class using this logger.
		 * @return a Logger class
		 * @see Logger class
		 * 
		 */		
		public function getLogger(className:String):Logger
		{
			var logger:Logger = new Logger(className, AddLog, new ConstructHelper());
			return logger;
		}
		
		/**
		 * Getter classNames gives you all the classes the logger has.
		 * 
		 * @return an ArrayCollection all classes names.
		 */		
		[Bindable]
		public function get classNames():ArrayCollection
		{
			return _classNames;
		}
		
		/**
		 * Function getLogInfo gives you all the current loges it has. You can special a LogFilterSetting for request some special log.
		 * 
		 * @param f the LogFilterSetting instance
		 * @return an ArrayCollection of relating logs.
		 * 
		 */		
		public function getLogInfo(f:LogFilterSetting = null):ArrayCollection
		{
			if (f == null)
			{
				return _logHistory;
			}
			
			var n:ArrayCollection = new ArrayCollection;
			for each (var l:LogStruct in _logHistory)
			{
				if (l.logLevel == LogLevel.LOG_LEVEL_DEBUG && f.showDebug == false)
				{
					continue;
				}
				
				if (l.logLevel == LogLevel.LOG_LEVEL_ERROR && _setting.showError == false)
				{
					continue;
				}
				
				if (f.onlyClass == "" || l.className == f.onlyClass)
				{
					n.addItem(l);
				}
			}
			
			return n;
		}
		
		/**
		 * Remove all the loges. 
		 * 
		 */		
		public function cleanLog():void
		{
			_logHistory.removeAll();
		}
		
		/** 
		 * @private
		 */		
		private function AddLog(val:LogStruct):void
		{
			val.logID = _logID;
			++_logID;
			
			if (_logHistory.length > _setting.maxLogLines)
			{
				for (var i:int = 0; i < _logHistory.length - _setting.maxLogLines; ++i)
				{
					_logHistory.removeItemAt(0);
				}
			}
			_logHistory.addItem(val);
			UpdateClassNames(val.className);
	
			dispatchEvent(new Event(EVENT_LOG_UPDATE));
			
			if (_setting.showTrace == true)
			{
				trace(val.className + ", " + val.functionName + ", " + val.text);
			}
		}
		
		/** 
		 * @private
		 */		
		private function UpdateClassNames(name:String):void
		{
			if (_classNames.contains(name) == false)
			{
				_classNames.addItem(name);
			}
		}
		
		/** 
		 * @private
		 */		
		private function OnLogSettingUpdate(e:Event):void
		{
			dispatchEvent(new Event(EVENT_LOG_UPDATE));
		}

	}
}

class LogManagerIniter{}