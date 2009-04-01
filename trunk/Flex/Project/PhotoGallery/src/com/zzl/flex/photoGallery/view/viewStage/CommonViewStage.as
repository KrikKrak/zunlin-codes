package com.zzl.flex.photoGallery.view.viewStage
{
	import com.zzl.flex.photoGallery.model.BasicPhotoInfo;
	import com.zzl.flex.photoGallery.model.GlobeModelLocator;
	import com.zzl.flex.photoGallery.view.photoStage.CommonPhotoStage;
	
	import flash.events.Event;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.core.Container;
	import mx.events.ResizeEvent;

	public class CommonViewStage extends Canvas
	{
		protected var _modelLocator:GlobeModelLocator = GlobeModelLocator.inst;
		protected var _photoChildren:ArrayCollection;
		
		protected var _mainStage:Container;
		
		protected var PHOTO_WIDTH:int = 160;
		protected var PHOTO_HEIGHT:int = 160;
		
		public function CommonViewStage()
		{
			super();
			
			ConsInit();
		}
		
		public function hasPhoto():Boolean
		{
			if (_photoChildren != null && _photoChildren.length > 0)
			{
				return true;
			}
			
			return false;
		}
		
		public function updateViewCenter(p:Point):void
		{
			if (this.transform == null)
			{
				return;
			}
			
			if (this.transform.perspectiveProjection == null)
			{
				this.transform.perspectiveProjection = new PerspectiveProjection;
			}

			var pp:PerspectiveProjection = this.transform.perspectiveProjection;
			if (pp.projectionCenter.x != p.x || pp.projectionCenter.y != p.y)
			{
				pp.projectionCenter = p;
				this.transform.perspectiveProjection = pp;
			}
		}
		
		public function updateViewDistance(n:Number):void
		{

		}
		
		protected function ConsInit():void
		{
			_mainStage = new Container;
			_mainStage.percentWidth = 100;
			_mainStage.percentHeight = 100;
			this.addChild(_mainStage);
			
			_photoChildren = new ArrayCollection;
			this.addEventListener(ResizeEvent.RESIZE, OnResize, false, 0, true);
			
			_modelLocator.addEventListener(GlobeModelLocator.E_PHOTO_LIST_UPDATE, OnPhotoListUpdate, false, 0, true);
			_modelLocator.addEventListener(GlobeModelLocator.E_DATA_SOURCE_UPDATE, OnDataSourceUpdate, false, 0, true);
			_modelLocator.addEventListener(GlobeModelLocator.E_PROJECTION_CENTER_UPDATE, OnProjectionCenterUpdate, false, 0, true);
			_modelLocator.addEventListener(GlobeModelLocator.E_PROJECTION_DISTANCE_UPDATE, OnProjectionDistanceUpdate, false, 0, true);
		}
		
		protected function OnProjectionCenterUpdate(e:Event):void
		{
			updateViewCenter(_modelLocator.projectionCenter);
		}
		
		protected function OnProjectionDistanceUpdate(e:Event):void
		{
			updateViewDistance(_modelLocator.projectionDistance);
		}
		
		protected function OnResize(e:ResizeEvent):void
		{
			if (hasPhoto == true && this.width != 0 && this.height != 0)
			{
				UpdatePhotoPosition();
			}
		}
		
		protected function UpdatePhotoPosition():void
		{
		}
		
		protected function OnDataSourceUpdate(e:Event):void
		{
			RemovePhotos();
		}
		
		protected function OnPhotoListUpdate(e:Event):void
		{
			var i:int = _photoChildren.length;
			var j:int = _modelLocator.photoList.length;
			
			for (var k:int = 0; k < i; ++k)
			{
				if (k < j)
				{
					(_photoChildren[k] as CommonPhotoStage).photoInfo = _modelLocator.photoList[k] as BasicPhotoInfo;
				}
				else
				{
					RemovePhoto(_photoChildren[k] as CommonPhotoStage);
				}
			}
			
			if (i < j)
			{
				for (k = i; k < j; ++k)
				{
					var pc:CommonPhotoStage = new CommonPhotoStage;
					_mainStage.addChild(pc);
					_photoChildren.addItem(pc);
					pc.photoInfo = _modelLocator.photoList[k] as BasicPhotoInfo;
					pc.updateSize(PHOTO_WIDTH, PHOTO_HEIGHT);
				}
			}
			else if (j < i)
			{
				for (k = 0; k < i - j; ++k)
				{
					_photoChildren.removeItemAt(_photoChildren.length - 1);
				}
			}
			
			UpdatePhotoPosition();
		}
		
		protected function RemovePhotos():void
		{
			for each (var p:CommonPhotoStage in _photoChildren)
			{
				RemovePhoto(p);
			}
			_photoChildren.removeAll();
		}
		
		protected function RemovePhoto(p:CommonPhotoStage):void
		{
			if (_mainStage.contains(p))
			{
				_mainStage.removeChild(p);
			}
			p.disposePhoto();
			p = null;
		}
		
	}
}