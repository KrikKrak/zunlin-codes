package com.larryzzl.iBlog.event
{
	import mx.containers.Canvas;
	
	public class MainAppEvent extends MateEvent
	{
		public static const LOAD_FLASH_VAR:String = "LOAD_FLASH_VAR";
		public static const REGISTER_APP:String = "REGISTER_APP";
		public static const APP_DID_LAUNCH:String = "APP_DID_LAUNCH";
		public static const SHOW_LOADING_OVERLAY:String = "SHOW_LOADING_OVERLAY";
		
		public var flashvarParams:Object;
		public var mainContentFrame:Canvas;
		public var mainFrame:Canvas;
		public var showLoadingOverylay:Boolean;
		
		public function MainAppEvent(type:String)
		{
			super(type);
		}

	}
}