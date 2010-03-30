package com.zzl.flex.familymenu.controller
{
	import com.zzl.flex.familymenu.model.GlobeModelLocator;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.core.WindowedApplication;
	import mx.events.ResizeEvent;
	
	public class CommonEventCenter extends EventDispatcher
	{
		// Events
		public static const E_APPLICATION_RESIZE:String = "ApplicationResizeEvent";
		
		// Static instence
		private static var _inst:CommonEventCenter;
		
		// variables
		private var _modelLocator:GlobeModelLocator = GlobeModelLocator.inst; 
		
		
		public static function get inst():CommonEventCenter
		{
			if (_inst == null)
			{
				_inst = new CommonEventCenter(new CommonEventCenterCreator);
			}
			
			return _inst;
		}
		
		public function CommonEventCenter(val:CommonEventCenterCreator){}
		
		public function initEvents():void
		{
			var mainApp:WindowedApplication = _modelLocator.mainApplication;
			
			// add resize event
			mainApp.addEventListener(ResizeEvent.RESIZE, OnMainApplicationResize, false, 0, true);
		}
		
		private function OnMainApplicationResize(event:ResizeEvent):void
		{
			dispatchEvent(new Event(E_APPLICATION_RESIZE));
		}
	}
}

class CommonEventCenterCreator{}