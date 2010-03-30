package com.zzl.flex.LogUrFeeling.controller
{
	import com.zzl.flex.LogUrFeeling.Model.FeelingCommands.*;
	import com.zzl.flex.LogUrFeeling.Model.MainModelLocator;
	import com.zzl.flex.LogUrFeeling.Service.*;
	import com.zzl.flex.LogUrFeeling.view.commonUI.LoadingOverlay;
	
	import flash.events.Event;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	
	public class MainController
	{
		private static var _inst:MainController;
		
		private var _mainModelLocator:MainModelLocator = MainModelLocator.inst;
		
		private var _loadingOverlay:LoadingOverlay;
		
		static public function get inst():MainController
		{
			if (_inst == null)
			{
				_inst = new MainController(new MainControllerConstrctor);
			}
			
			return _inst;
		}
		
		public function MainController(val:MainControllerConstrctor)
		{
			InitListener();
		}
		
		public function handleCommand(c:BaseCommand):void
		{
			switch (c.commandName)
			{
				// TODO: we might need separate all these service relating command to another controller class
				// Service relating command handler
				case SubmitFeelingCommand.C_SUBMIT_FEELING:
					SubmitFeeling(c as SubmitFeelingCommand);
			}
		}
		
		private function SubmitFeeling(c:SubmitFeelingCommand):void
		{
			var p:Object = {feeling: c.feeling, name: c.name, email: c.email, note: c.note, ip: _mainModelLocator.userIp};
			var s:SubmitFeelingService = new SubmitFeelingService(_mainModelLocator.submitServiceUrl, p);
			s.addEventListener(s.E_REQUEST_COMPLETE, OnSubmitFeelingComplete, false, 0, true);
			s.addEventListener(s.E_REQUEST_ERROR, OnSubmitFeelingError, false, 0, true);
			s.addEventListener(s.E_REQUEST_START, OnServiceStart, false, 0, true);
			s.send();
		}
		
		private function OnSubmitFeelingComplete(e:Event):void
		{
			ShowLoadingOverlay(false);
			(e.target as SubmitFeelingService).close();
			
			//	TODO: We need implement our own Alert Wnd
			Alert.show("Thanks for sharing your feeling!.", "Success", Alert.OK, null, OnSubmitFeelingCompleteOK);
		}
		
		private function OnSubmitFeelingCompleteOK(e:CloseEvent):void
		{
			_mainModelLocator.feelingLogged = true;
		}
		
		private function OnSubmitFeelingError(e:Event):void
		{
			ShowLoadingOverlay(false);
			(e.target as SubmitFeelingService).close();
			
			//	TODO: We need implement our own Alert Wnd
			Alert.show("Can not submit now! Call 911.", "Error", Alert.OK);
		}
		
		private function OnServiceStart(e:Event):void
		{
			ShowLoadingOverlay(true, false);
		}
		
		private function InitListener():void
		{
			_mainModelLocator.addEventListener(MainModelLocator.E_MODULE_LOAD_START_UPDATE, OnModuleLoadStart, false, 0, true);
			_mainModelLocator.addEventListener(MainModelLocator.E_MODULE_LOAD_READY_UPDATE, OnModuleLoadReady, false, 0, true);
			_mainModelLocator.addEventListener(MainModelLocator.E_MODULE_LOAD_ERROR_UPDATE, OnModuleLoadError, false, 0, true);
		}
		
		private function OnModuleLoadStart(e:Event):void
		{
			ShowLoadingOverlay(true);
		}
		
		private function OnModuleLoadReady(e:Event):void
		{
			ShowLoadingOverlay(false);
		}
		
		private function OnModuleLoadError(e:Event):void
		{
			ShowLoadingOverlay(false);
			
			//	TODO: We need implement our own Alert Wnd
			Alert.show("Page loads error!", "Error", Alert.OK);
		}
		
		private function ShowLoadingOverlay(show:Boolean, progress:Boolean = true):void
		{
			if (show == true)
			{
				if (_loadingOverlay == null)
				{
					_loadingOverlay = new LoadingOverlay;
				}
				_loadingOverlay.useProgress = progress;
				_mainModelLocator.applicationContainer.addChild(_loadingOverlay);
			}
			else
			{
				if (_loadingOverlay != null && _mainModelLocator.applicationContainer.contains(_loadingOverlay))
				{
					_mainModelLocator.applicationContainer.removeChild(_loadingOverlay);
				}
			}
		}

	}
}

class MainControllerConstrctor
{}