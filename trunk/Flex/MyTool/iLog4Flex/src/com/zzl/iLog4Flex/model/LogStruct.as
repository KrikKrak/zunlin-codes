package com.zzl.iLog4Flex.model
{
	public class LogStruct
	{
		public var className:String = "";
		public var functionName:String = "";
		public var text:String = "";
		public var logLevel:int = LogLevel.LOG_LEVEL_BUTTOM;
		
		public var logID:int = 0;
		
		public function LogStruct(cn:String, fn:String, t:String, l:int):void
		{
			className = cn;
			functionName = fn;
			text = t;
			logLevel = l;
		}
	}
}