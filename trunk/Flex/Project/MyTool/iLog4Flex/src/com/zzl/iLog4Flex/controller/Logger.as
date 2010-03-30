package com.zzl.iLog4Flex.controller
{
	import com.zzl.iLog4Flex.model.LogLevel;
	import com.zzl.iLog4Flex.model.LogSetting;
	import com.zzl.iLog4Flex.model.LogStruct;
	
	/**
	 * Logger is the class you log you code. You can use different log level for different cases.
	 * This class SHOULD ONLY BE CREATED from LogManager
	 *   
	 * @author larryzzl
	 * 
	 */	
	public class Logger
	{
		private var _className:String;
		private var _setting:LogSetting;
		private var _addLogFunction:Function;
		
		/**
		 * The constructor
		 * @param className the name of the class which will use the logger
		 * @param adFn the callback function for adding a log
		 * @param helper a helper class to make sure the Logger can only be created from LogManager
		 * 
		 */		
		public function Logger(className:String, adFn:Function, helper:ConstructHelper)
		{
			_className = className;
			_addLogFunction = adFn;
			
			_setting = LogSetting.inst;
		}

		/**
		 * Function self outputs the class name itself with the TOP_LEVEL of log. 
		 * 
		 */		
		public function self():void
		{
			var l:LogStruct = new LogStruct(_className, "", "", LogLevel.LOG_LEVEL_TOP);
			writeLog(l);
		}
		
		/**
		 * Function log logs a simple log with the TOP_LEVEL of log.
		 *  
		 * @param text the text you want to log
		 */		
		public function log(text:String):void
		{
			var l:LogStruct = new LogStruct(_className, "\t", text, LogLevel.LOG_LEVEL_TOP);
			writeLog(l);
		}
		
		/**
		 * Function fine logs a normal log with FINE_LEVEL of log.
		 *  
		 * @param functionName the function name where the log happens
		 * @param text the text you want to log
		 * 
		 */		
		public function fine(functionName:String, text:String):void
		{
			var l:LogStruct = new LogStruct(_className, functionName, text, LogLevel.LOG_LEVEL_FINE);
			writeLog(l);
		}
		
		/**
		 * Function error logs a normal log with ERROR_LEVEL of log.
		 *  
		 * @param functionName the function name where the log happens
		 * @param text the text you want to log
		 * 
		 */	
		public function error(functionName:String, text:String):void
		{
			var l:LogStruct = new LogStruct(_className, functionName, text, LogLevel.LOG_LEVEL_ERROR);
			writeLog(l);
		}
		
		/**
		 * Function debug logs a normal log with DEBUG_LEVEL of log.
		 *  
		 * @param functionName the function name where the log happens
		 * @param text the text you want to log
		 * 
		 */	
		public function debug(functionName:String, text:String):void
		{
			if (_setting.useDebugMode == true)
			{
				var l:LogStruct = new LogStruct(_className, functionName, text, LogLevel.LOG_LEVEL_DEBUG);
				writeLog(l);
			}
		}
		
		/**
		 * @private 
		 */		
		private function writeLog(l:LogStruct):void
		{
			if (_addLogFunction != null)
			{
				_addLogFunction(l);
			}
		}
	}
}