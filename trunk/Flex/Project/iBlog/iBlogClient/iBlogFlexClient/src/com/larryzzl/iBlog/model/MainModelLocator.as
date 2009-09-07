package com.larryzzl.iBlog.model
{
	import mx.containers.Canvas;
	
	[Bindable]
	public class MainModelLocator
	{
		private static var _inst: MainModelLocator;
		
		public static function get inst():MainModelLocator
		{
			if (_inst == null)
			{
				_inst = new MainModelLocator(new MainModelLocatorHelpClass);
			}
			
			return _inst;
		}
		
		public function MainModelLocator(val:MainModelLocatorHelpClass)
		{
		}
		
		public var debugMode:Boolean = true;
		
		public var sessionKey:String = "";
		
		public var mainFrame:Canvas;
		
		public var mainContentFrame:Canvas;
		
		public var showLoadingOverlay:Boolean = false;

	}
}

class MainModelLocatorHelpClass{}