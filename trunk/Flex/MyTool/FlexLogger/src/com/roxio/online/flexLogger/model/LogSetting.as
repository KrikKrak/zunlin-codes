package com.roxio.online.flexLogger.model
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	[Event(name="com.roxio.online.flexLogger.LogSettingUpdate", type="flash.events.Event")]
	
	[Bindable]
	public class LogSetting extends EventDispatcher
	{
		public static const EVENT_LOG_SETTING_UPDATE:String = "com.roxio.online.flexLogger.LogSettingUpdate";
		
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

	}
}

class LogSettingInner{}