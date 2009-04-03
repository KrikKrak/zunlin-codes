package com.zzl.flex.photoGallery.business
{
	import com.adobe.xml.syndication.rss.Item20;
	import com.adobe.xml.syndication.rss.RSS20;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.collections.ArrayCollection;
	
	public class RSS2ParserHelp
	{
		private var _callbackFunction:Function;
		private var _loader:URLLoader;
		
		public function RSS2ParserHelp(cbf:Function)
		{
			_callbackFunction = cbf;
		}
		
		public function parseRSS2(rssLink:String):void
		{
			_loader = new URLLoader;
			_loader.addEventListener(Event.COMPLETE, OnComplete, false, 0, true);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, OnError, false, 0, true);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, OnSecurityError, false, 0, true);
			_loader.addEventListener(ProgressEvent.PROGRESS, OnProgress);
			
			var rq:URLRequest = new URLRequest(rssLink);
			_loader.load(rq);
		}
		
		private function OnProgress(e:ProgressEvent):void
		{
			//trace(e.bytesLoaded, e.bytesTotal);
		}
		
		private function OnComplete(e:Event):void
		{
			trace("Rss load complete");
			var xmlString:String = URLLoader(e.target).data;
			var rssParser:RSS20 = new RSS20;
			rssParser.parse(xmlString);
			
			var a:ArrayCollection = new ArrayCollection;
			for each (var item:Item20 in rssParser.items)
			{
				a.addItem(GetContentURL(item.xml));
			}
			
			CleanUp();
			if (_callbackFunction != null)
			{
				_callbackFunction(a);
			}
		}
		
		private function OnError(e:IOErrorEvent):void
		{
			ReturnError();
		}
		
		private function OnSecurityError(e:SecurityErrorEvent):void
		{
			ReturnError();
		}
		
		private function ReturnError():void
		{
			CleanUp();
			if (_callbackFunction != null)
			{
				_callbackFunction(new ArrayCollection);
			}
		}
		
		private function CleanUp():void
		{
			if (_loader != null)
			{
				_loader.removeEventListener(Event.COMPLETE, OnComplete);
				_loader.removeEventListener(IOErrorEvent.IO_ERROR, OnError);
				_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, OnSecurityError);
				_loader.removeEventListener(ProgressEvent.PROGRESS, OnProgress);
				_loader = null;
			}
		}
		
		private function GetContentURL(xml:XMLList):String
		{
			for each (var x:XML in xml.children())
			{
				if (x.localName() == "content")
				{
					return(x.@url);
				}
			}
			return "";
		}

	}
}