package com.Roxio.PhotoStar.Server
{
	import com.Roxio.PhotoStar.Mode.GlobeSetting;
	import com.Roxio.PhotoStar.Mode.TargetLoadEvent;
	import com.Roxio.OnlineObject.DebugTool.TraceTool;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	
	import mx.controls.Image;
	
	public class DataController extends EventDispatcher
	{
		private static var _controller:DataController;
		
		private var _dataHolder:DataHolder;
		
		public function DataController()
		{
			super(null);
		}
		
		public static function get controller():DataController
		{
			if (_controller == null)
			{
				_controller = new DataController;
			}
			return _controller;
		}
		
		public function get dataChanged():Boolean
		{
			if (_dataHolder != null && _dataHolder.ready == true)
			{
				return _dataHolder.dataChanged;
			}
			else
			{
				TraceTool.TraceError("DataController -- get dataChanged -- _dataHolder is null!");
				return false;
			}
		}
		
		public function set dataChanged(val:Boolean):void
		{
			if (_dataHolder != null && _dataHolder.ready == true)
			{
				_dataHolder.dataChanged = val;
			}
		}
		
		public function get image():Image
		{
			if (_dataHolder != null && _dataHolder.ready == true)
			{
				return _dataHolder.data;
			}
			else
			{
				return null;
			}
		}
		
		public function get bitmapData():BitmapData
		{
			if (_dataHolder != null && _dataHolder.ready == true)
			{
				return (_dataHolder.data.content as Bitmap).bitmapData;
			}
			else
			{
				return null;
			}
		}
		
		public function loadDemoImage():void
		{
			CreateNewData(GlobeSetting.demoPhotoUrl);
		}
		
		private function CreateNewData(url:String):void
		{
			if (_dataHolder != null)
			{
				_dataHolder.removeEventListener(TargetLoadEvent.IMAGE_START_LOAD, OnDataStartLoad);
				_dataHolder.removeEventListener(TargetLoadEvent.IMAGE_LOADING, OnDataLoading);
				_dataHolder.removeEventListener(TargetLoadEvent.IMAGE_LOADED, OnDataLoaded);
				_dataHolder.removeEventListener(TargetLoadEvent.IMAGE_LOAD_ERROR, OnDataLoadError);
				_dataHolder = null;
			}
			
			_dataHolder = new DataHolder;
			_dataHolder.addEventListener(TargetLoadEvent.IMAGE_START_LOAD, OnDataStartLoad, false, 0, true);
			_dataHolder.addEventListener(TargetLoadEvent.IMAGE_LOADING, OnDataLoading, false, 0, true);
			_dataHolder.addEventListener(TargetLoadEvent.IMAGE_LOADED, OnDataLoaded, false, 0, true);
			_dataHolder.addEventListener(TargetLoadEvent.IMAGE_LOAD_ERROR, OnDataLoadError, false, 0, true);
			
			_dataHolder.imageSource = url;
		}
		
		private function OnDataStartLoad(event:TargetLoadEvent):void
		{
			var e:TargetLoadEvent = new TargetLoadEvent(TargetLoadEvent.IMAGE_START_LOAD);
			dispatchEvent(e);
		}
		
		private function OnDataLoading(event:TargetLoadEvent):void
		{
			var e:TargetLoadEvent = new TargetLoadEvent(TargetLoadEvent.IMAGE_LOADING);
			e.loadPercent = event.loadPercent;
			dispatchEvent(e);
		}
		
		private function OnDataLoaded(event:TargetLoadEvent):void
		{
			GlobeSetting.currentTargetUrl = _dataHolder.imageSource;
			
			var e:TargetLoadEvent = new TargetLoadEvent(TargetLoadEvent.IMAGE_LOADED);
			dispatchEvent(e);
		}
		
		private function OnDataLoadError(event:TargetLoadEvent):void
		{
			var e:TargetLoadEvent = new TargetLoadEvent(TargetLoadEvent.IMAGE_LOADING);
			e.errorID = event.errorID;
			e.errorText = event.errorText;
			dispatchEvent(e);
		}

	}
}