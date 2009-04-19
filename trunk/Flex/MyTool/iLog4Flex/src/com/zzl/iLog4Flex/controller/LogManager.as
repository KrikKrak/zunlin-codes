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
		
		public function set showTrace(val:Boolean):void
		{
			_setting.showTrace = val;
		}
		
		public function set maxLogLines(val:int):void
		{
			_setting.maxLogLines = val;
		}
		
		public function getLogger(className:String):Logger
		{
			var logger:Logger = new Logger(className, AddLog, new ConstructHelper());
			return logger;
		}
		
		[Bindable]
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