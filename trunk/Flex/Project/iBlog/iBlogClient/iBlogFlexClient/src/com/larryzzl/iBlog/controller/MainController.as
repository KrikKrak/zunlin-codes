package com.larryzzl.iBlog.controller
{
	import com.larryzzl.iBlog.model.MainModelLocator;
	
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
			
		}
		
		public function showLoadingOverlay(show:Boolean):void
		{
			_mainModel.showLoadingOverlay = show;
		}

	}
}