package com.larryzzl.iBlog.model
{
	import com.larryzzl.iBlog.model.modelDef.BlogArticle;
	import com.larryzzl.iBlog.model.modelDef.UserInfo;
	
	import mx.containers.Canvas;
	
	[Bindable]
	public class MainModelLocator
	{
		public static const MAX_NUMBER_OF_ITEM_READ_ONCE:Number = 20;
		
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
		
		public var currentUser:UserInfo;
		
		public var mainFrame:Canvas;
		
		public var mainContentFrame:Canvas;
		
		public var showLoadingOverlay:Boolean = false;
		
		public var localBlogArticles:Vector.<BlogArticle> = new Vector.<BlogArticle>();

	}
}

class MainModelLocatorHelpClass{}