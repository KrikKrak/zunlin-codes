package com.roxio.online.flexLogger.controller
{
	import com.roxio.online.flexLogger.model.LogFilterSetting;
	import com.roxio.online.flexLogger.model.LogLevel;
	import com.roxio.online.flexLogger.model.LogSetting;
	import com.roxio.online.flexLogger.model.LogStruct;
	import com.roxio.online.flexLogger.view.LogWnd;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	
	[Event(name="com.roxio.online.flexLogger.LogUpdate", type="flash.events.Event")]
	
	public class LogManager extends EventDispatcher
	{
		public static const EVENT_LOG_UPDATE:String = "com.roxio.online.flexLogger.LogUpdate";

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
		
		private function Init():void
		{
			_classNames.addItem("All");
			_setting.addEventListener(LogSetting.EVENT_LOG_SETTING_UPDATE, OnLogSettingUpdate, false, 0, true);
		}
		
		public function showLog():void
		{
			LogWnd.show();
		}
		
		public function set useDebugMode(val:Boolean):void
		{
			_setting.useDebugMode = val;
		}
		
		public function getLogger(className:String):Logger
		{
			var logger:Logger = new Logger(className, AddLog, new ConstructHelper());
			return logger;
		}
		
		public function get classNames():ArrayCollection
		{
			return _classNames;
		}
		
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
		
		public function cleanLog():void
		{
			_logHistory.removeAll();
		}
		
		private function AddLog(val:LogStruct):void
		{
			val.logID = _logID;
			++_logID;
			_logHistory.addItem(val);
			UpdateClassNames(val.className);
			
			trace(val.logLevel, val.className, val.functionName, val.text);
			dispatchEvent(new Event(EVENT_LOG_UPDATE));
		}
		
		private function UpdateClassNames(name:String):void
		{
			if (_classNames.contains(name) == false)
			{
				_classNames.addItem(name);
			}
		}
		
		private function OnLogSettingUpdate(e:Event):void
		{
			dispatchEvent(new Event(EVENT_LOG_UPDATE));
		}

	}
}

class LogManagerIniter{}