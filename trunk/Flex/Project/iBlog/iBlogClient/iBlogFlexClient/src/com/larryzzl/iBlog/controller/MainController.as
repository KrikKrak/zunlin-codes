package com.larryzzl.iBlog.controller
{
	import com.larryzzl.iBlog.model.MainModelLocator;
	import com.larryzzl.iBlog.model.modelDef.UserInfo;
	import com.larryzzl.iBlog.service.ReadArticleFromMockData;
	
	import mx.containers.Canvas;
	
	public class MainController
	{
		private var _mainModel:MainModelLocator = MainModelLocator.inst;
		
		public function MainController()
		{
		}
		
		public function loadFlashVar(param:Object):void
		{
			if (param.sessionKey != null)
			{
				_mainModel.debugMode = false;
				_mainModel.sessionKey = String(param.sessionKey);
			}
			else
			{
				_mainModel.debugMode = true;
			}
		}
		
		public function registerApp(mainFrame:Canvas, mainContentFrame:Canvas):void
		{
			_mainModel.mainFrame = mainFrame;
			_mainModel.mainContentFrame = mainContentFrame;
		}
		
		/**
		 * Here is the entrance of the whole app starts.
		 * This function will be called after all UI is ready, so basically, we should do some server connect here.
		 */		
		public function initializeApp():void
		{
			trace("MainController initializeApp called");
			
			// get login user info
			// TODO: we should get user info from site, here is just a demo
			var ui:UserInfo = new UserInfo;
			ui.userName = "Larry";
			ui.userId = "1";
			ui.userEmail = "larry@larry.com";
			ui.isUserAuthor = true;
			_mainModel.currentUser = ui;
			
			readLatestArticles();
		}
		
		public function showLoadingOverlay(show:Boolean):void
		{
			_mainModel.showLoadingOverlay = show;
		}
		
		public function readLatestArticles():void
		{
			var rd:ReadArticleFromMockData = new ReadArticleFromMockData();
			rd.readArticle();
		}

	}
}