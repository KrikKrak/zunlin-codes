package com.roxio.online.flexLogger.controller
{
	import com.roxio.online.flexLogger.model.LogLevel;
	import com.roxio.online.flexLogger.model.LogSetting;
	import com.roxio.online.flexLogger.model.LogStruct;
	
	public class Logger
	{
		private var _className:String;
		private var _setting:LogSetting;
		private var _addLogFunction:Function;
		
		public function Logger(className:String, adFn:Function, helper:ConstructHelper)
		{
			_className = className;
			_addLogFunction = adFn;
			
			_setting = LogSetting.inst;
		}

		public function self():void
		{
			var l:LogStruct = new LogStruct(_className, "", "", LogLevel.LOG_LEVEL_TOP);
			writeLog(l);
		}
		
		public function fine(functionName:String, text:String):void
		{
			var l:LogStruct = new LogStruct(_className, functionName, text, LogLevel.LOG_LEVEL_FINE);
			writeLog(l);
		}
		
		public function error(functionName:String, text:String):void
		{
			var l:LogStruct = new LogStruct(_className, functionName, text, LogLevel.LOG_LEVEL_ERROR);
			writeLog(l);
		}
		
		public function debug(functionName:String, text:String):void
		{
			if (_setting.useDebugMode == true)
			{
				var l:LogStruct = new LogStruct(_className, functionName, text, LogLevel.LOG_LEVEL_DEBUG);
				writeLog(l);
			}
		}
		
		private function writeLog(l:LogStruct):void
		{
			if (_addLogFunction != null)
			{
				_addLogFunction(l);
			}
		}
	}
}