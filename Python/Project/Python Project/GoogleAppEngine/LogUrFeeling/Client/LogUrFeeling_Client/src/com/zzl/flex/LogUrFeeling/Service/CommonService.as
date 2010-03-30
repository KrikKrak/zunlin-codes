package com.zzl.flex.LogUrFeeling.Service
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.InvokeEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	public class CommonService extends EventDispatcher
	{
		public const E_REQUEST_ERROR:String = "Event_RequestError";
		public const E_REQUEST_COMPLETE:String = "Event_RequestComplete";
		public const E_REQUEST_START:String = "Event_RequestStart";
		
		protected var _httpRequest:HTTPService;
		protected var _serviceName:String = "CommonService";
		
		public function CommonService()
		{
			_httpRequest = new HTTPService;
			_httpRequest.addEventListener(FaultEvent.FAULT, OnRequestFault);
			_httpRequest.addEventListener(InvokeEvent.INVOKE, OnRequestInvoke);
			_httpRequest.addEventListener(ResultEvent.RESULT, OnRequestResult);
			
			PostInit();
		}
		
		// This function can be overrided for some special http service setting by sub classes.
		protected function PostInit():void
		{}
		
		public function send():void
		{
			_httpRequest.send();
		}
		
		public function close():void
		{
			_httpRequest.disconnect();
			_httpRequest.removeEventListener(FaultEvent.FAULT, OnRequestFault);
			_httpRequest.removeEventListener(InvokeEvent.INVOKE, OnRequestInvoke);
			_httpRequest.removeEventListener(ResultEvent.RESULT, OnRequestResult);
		}
		
		protected function OnRequestFault(e:FaultEvent):void
		{
			dispatchEvent(new Event(E_REQUEST_ERROR));
		}
		
		protected function OnRequestInvoke(e:InvokeEvent):void
		{
			dispatchEvent(new Event(E_REQUEST_START));
		}
		
		protected function OnRequestResult(e:ResultEvent):void
		{
			dispatchEvent(new Event(E_REQUEST_COMPLETE));
		}

	}
}