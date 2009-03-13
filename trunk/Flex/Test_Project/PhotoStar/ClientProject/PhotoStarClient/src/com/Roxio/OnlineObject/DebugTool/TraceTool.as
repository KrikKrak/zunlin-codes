package com.Roxio.OnlineObject.DebugTool
{
	public class TraceTool
	{
		public static const TEXT:String = "Text";
		public static const ERROR:String = "Error";

		private static var _enableTraceText:Boolean = true;
		private static var _enableTraceError:Boolean = true;
		
		public function TraceTool()
		{
			super();
		}
		
		public static function set enableTraceAll(val:Boolean):void
		{
			_enableTraceText = val;
			_enableTraceError = val;
		}
		
		public static function set enableTraceText(val:Boolean):void
		{
			_enableTraceText = val;
		}
		
		public static function set enableTraceError(val:Boolean):void
		{
			_enableTraceError = val;
		}
		
		public static function Trace(traceString:String, traceType:String = TEXT):void
		{
			if (traceType == TEXT)
			{
				if (_enableTraceText == true)
				{
					trace(traceString);
				}
			}
			else if (traceType == ERROR)
			{
				if (_enableTraceError == true)
				{
					trace(traceString);
				}
			}
		}
		
		public static function TraceError(traceString:String):void
		{
			if (_enableTraceError == true)
			{
				trace(traceString);
			}
		}

	}
}