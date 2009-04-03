package com.zzl.flex.photoGallery.controller
{
	import com.zzl.flex.photoGallery.model.BasicPhotoInfo;
	import com.zzl.flex.photoGallery.model.GlobeModelLocator;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	
	import mx.collections.ArrayCollection;
	
	public class DataLoaderController
	{
		private static var _inst:DataLoaderController;
		
		private var _modelLocator:GlobeModelLocator = GlobeModelLocator.inst;
		
		private var _totalNumber:int = 0;
		private var _doneNumber:int = 0;
		private var _errorNumber:int = 0;
		private var _photos:ArrayCollection;
		
		public static function get inst():DataLoaderController
		{
			if (_inst == null)
			{
				_inst = new DataLoaderController(new DataLoaderControllerCreator);
			}
			
			return _inst;
		}
		
		public function DataLoaderController(val:DataLoaderControllerCreator){}
		
		public function readData(paths:ArrayCollection):void
		{
			CleanLoaders();
			_totalNumber = paths.length;
			switch (_modelLocator.dataSource)
			{
				case GlobeModelLocator.DATA_SOURCE_LOCAL:
					LoadImgFromLocal(paths);
					break;
					
				case GlobeModelLocator.DATA_SOURCE_RSS:
					LoadImgFromRss(paths);
					break;
					
				case GlobeModelLocator.DATA_SOURCE_TEST:
					LoadImgFromTestFolder(paths);
					break;
			}
		}
		
		private function LoadImgFromRss(paths:ArrayCollection):void
		{
			LoadImgFromTestFolder(paths);
		}
		
		private function LoadImgFromLocal(paths:ArrayCollection):void
		{
			LoadImgFromTestFolder(paths);
		}
		
		private function LoadImgFromTestFolder(paths:ArrayCollection):void
		{
			_photos = new ArrayCollection;
			_errorNumber = 0;
			_doneNumber = 0;
			for each(var p:String in paths)
			{
				var ur:URLRequest = new URLRequest(p);
				var loader:Loader = new Loader;
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, OnTestFileLoaded, false, 0, true);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, OnTestFileIOError, false, 0, true);
				loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, OnTestFileLoadProgress, false, 0, true);
				
				var photo:BasicPhotoInfo = new BasicPhotoInfo;
				photo.fileName = p;
				photo.sourceURL = p;
				photo.loadStatus = GlobeModelLocator.SOURCE_LOADING;
				photo.loader = loader;
				_photos.addItem(photo);
				
				loader.load(ur);
			}
			
			_modelLocator.photoList = _photos;
		}
		
		private function OnTestFileLoaded(e:Event):void
		{
			_doneNumber++;
			trace("_doneNumber", _doneNumber);
			
			var li:LoaderInfo = e.target as LoaderInfo;
			for each (var p:BasicPhotoInfo in _photos)
			{
				if (li.loader == p.loader)
				{
					p.loadStatus = GlobeModelLocator.SOURCE_LOAD_FINISHED;
					p.data = (li.content as Bitmap).bitmapData;
					p.initWidth = p.data.width;
					p.initHeight = p.data.height;
					p.loader = null;
					
					CleanListener(li);
				}
			}
			
			UpdateLoadStatus();
		}
		
		private function OnTestFileIOError(e:IOErrorEvent):void
		{
			_errorNumber++;
			trace("_errorNumber", _errorNumber);
			
			var li:LoaderInfo = e.target as LoaderInfo;
			for each (var p:BasicPhotoInfo in _photos)
			{
				if (li.loader == p.loader)
				{
					p.loadStatus = GlobeModelLocator.SOURCE_LOAD_ERROR;
					p.data = null;
					p.initWidth = 0;
					p.initHeight = 0;
					p.loader = null;
					
					CleanListener(li);
				}
			}
			
			UpdateLoadStatus();
		}
		
		private function OnTestFileLoadProgress(e:ProgressEvent):void
		{
			var li:LoaderInfo = e.target as LoaderInfo;
			var n:int = 0;
			for each (var p:BasicPhotoInfo in _photos)
			{
				if (li.loader == p.loader)
				{
					p.loadPercent = int(100 * e.bytesLoaded / e.bytesTotal);
				}
				
				n += p.loadPercent;
			}
			_modelLocator.entirLoadingProgress = int(n / _photos.length);
			//trace(e.bytesLoaded, e.bytesTotal);
			
			UpdateLoadStatus();
		}
		
		private function UpdateLoadStatus():void
		{
			_modelLocator.photoList = _modelLocator.photoList;
			if (_doneNumber + _errorNumber == _totalNumber)
			{
				_modelLocator.sourceLoadStatus = (_doneNumber == 0) ? GlobeModelLocator.SOURCE_LOAD_ERROR : GlobeModelLocator.SOURCE_LOAD_FINISHED;
				_photos.removeAll();
			}
		}
		
		private function CleanLoaders():void
		{
			if (_photos != null && _photos.length > 0)
			{
				for each (var p:BasicPhotoInfo in _photos)
				{
					if (p.loader != null)
					{
						// still in loader
						(p.loader as Loader).close();
						p.loader = null;
					}
					else
					{
						// load finish or load error
						//p.data.dispose();
					}
					p = null;
				}
				_photos.removeAll();
				_photos = null;
			}
		}
		
		private function CleanListener(li:LoaderInfo):void
		{
			li.removeEventListener(Event.COMPLETE, OnTestFileLoaded);
			li.removeEventListener(IOErrorEvent.IO_ERROR, OnTestFileIOError);
			li.removeEventListener(ProgressEvent.PROGRESS, OnTestFileLoadProgress);
		}
	}
}

class DataLoaderControllerCreator{}