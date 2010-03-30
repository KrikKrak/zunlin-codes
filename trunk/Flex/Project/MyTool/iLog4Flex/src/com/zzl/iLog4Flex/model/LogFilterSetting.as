package com.zzl.iLog4Flex.model
{
	public class LogFilterSetting
	{
		public var showDebug:Boolean = true;
		public var showError:Boolean = true;
		public var onlyClass:String = "";
		
		public function LogFilterSetting(sd:Boolean = true, se:Boolean = true, oc:String = ""):void
		{
			showDebug = sd;
			showError = se;
			onlyClass = oc;
		}
	}
}