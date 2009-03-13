package com.Roxio.PhotoStar.Server
{
	import com.Roxio.OnlineObject.DebugTool.TraceTool;
	import com.Roxio.PhotoStar.Mode.TargetLoadEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	
	import mx.controls.Image;

	public class DataHolder extends EventDispatcher
	{
		private var _image:Image;
		private var _imageReady:Boolean = false;
		
		public var dataChanged:Boolean = false;
		
		public function DataHolder()
		{
			super(null);
			
			_image = new Image;
			_image.autoLoad = false;
			_image.addEventListener(Event.COMPLETE, OnImageLoaded, false, 0, true);
			_image.addEventListener(ProgressEvent.PROGRESS, OnImageLoading, false, 0, true);
			_image.addEventListener(IOErrorEvent.IO_ERROR, OnImageLoadError, false, 0, true);
		}
		
		public function get imageSource():String
		{
			return _image.source.toString();
		}
		
		public function set imageSource(url:String):void
		{
			TraceTool.Trace("DataHolder -- imageSource -- Image start load, source: " + url.toString());
			_image.source = url;
			
			_imageReady = false;
			var e:TargetLoadEvent = new TargetLoadEvent(TargetLoadEvent.IMAGE_START_LOAD);
			dispatchEvent(e);
			
			_image.load();
		}
		
		public function get ready():Boolean
		{
			return _imageReady;
		}
		
		public function get data():Image
		{
			return _image;
		}
		
		private function OnImageLoaded(event:Event):void
		{
			TraceTool.Trace("DataHolder -- OnImageLoaded -- Image load complete");
			_imageReady = true;
			var e:TargetLoadEvent = new TargetLoadEvent(TargetLoadEvent.IMAGE_LOADED);
			dispatchEvent(e);
		}
		
		private function OnImageLoading(event:ProgressEvent):void
		{
			var e:TargetLoadEvent = new TargetLoadEvent(TargetLoadEvent.IMAGE_LOADING);
			e.loadPercent = event.bytesLoaded / event.bytesTotal;
			dispatchEvent(e);
		}
		
		private function OnImageLoadError(event:IOErrorEvent):void
		{
			var e:TargetLoadEvent = new TargetLoadEvent(TargetLoadEvent.IMAGE_LOADING);
			//e.errorID = event.errorID;
			e.errorText = event.text;
			dispatchEvent(e);
		}
		
	}
}