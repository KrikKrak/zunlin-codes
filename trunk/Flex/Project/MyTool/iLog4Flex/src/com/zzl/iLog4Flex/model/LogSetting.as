package com.zzl.iLog4Flex.model
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	
	[Event(name="com.zzl.iLog4Flex.LogSettingUpdate", type="flash.events.Event")]
	
	[Bindable]
	public class LogSetting extends EventDispatcher
	{
		public static const EVENT_LOG_SETTING_UPDATE:String = "com.zzl.iLog4Flex.LogSettingUpdate";
		
		private static var _inst:LogSetting;
		
		public function LogSetting(val:LogSettingInner){}
		
		public static function get inst():LogSetting
		{
			if (_inst == null)
			{
				_inst = new LogSetting(new LogSettingInner);
			}
			return _inst;
		}
		
		private function UpdateSetting():void
		{
			dispatchEvent(new Event(EVENT_LOG_SETTING_UPDATE));
		}
		
		private var _useDebugMode:Boolean = true;
		public function set useDebugMode(val:Boolean):void
		{
			_useDebugMode = val;
			UpdateSetting();
		}
		
		public function get useDebugMode():Boolean
		{
			return _useDebugMode;
		}
		
		private var _showDebug:Boolean = true;
		public function set showDebug(val:Boolean):void
		{
			_showDebug = val;
			UpdateSetting();
		}
		
		public function get showDebug():Boolean
		{
			return _showDebug;
		}
		
		private var _showError:Boolean = true;
		public function set showError(val:Boolean):void
		{
			_showError = val;
			UpdateSetting();
		}
		
		public function get showError():Boolean
		{
			return _showError;
		}
		
		private var _showClass:String = "";
		public function set showClass(val:String):void
		{
			if (val == "All")
			{
				_showClass = "";
			}
			else
			{
				_showClass = val;
			}
			UpdateSetting();
		}
		
		public function get showClass():String
		{
			return _showClass;
		}
		
		private var _maxLogLines:int = 2000;
		public function set maxLogLines(val:int):void
		{
			_maxLogLines = val;
			UpdateSetting();
		}
		
		public function get maxLogLines():int
		{
			return _maxLogLines;
		}
		
		private var _showTrace:Boolean = true;
		public function set showTrace(val:Boolean):void
		{
			_showTrace = val;
			UpdateSetting();
		}
		
		public function get showTrace():Boolean
		{
			return _showTrace;
		}
	}
}

class LogSettingInner{}