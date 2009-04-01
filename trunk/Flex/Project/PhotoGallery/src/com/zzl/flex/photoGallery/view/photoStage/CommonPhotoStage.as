package com.zzl.flex.photoGallery.view.photoStage
{
	import caurina.transitions.Tweener;
	
	import com.zzl.flex.photoGallery.model.BasicPhotoInfo;
	import com.zzl.flex.photoGallery.view.Reflector;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import mx.controls.Image;
	import mx.controls.Label;
	import mx.core.Container;

	public class CommonPhotoStage extends Container
	{
		private var _photoInfo:BasicPhotoInfo;
		private var _photoContainer:Container
		private var _photo:Image;
		private var _photoR:Reflector;
		private var _loadPercent:Label;
		
		private var _imageAreaWidth:int = 0;
		private var _imageAreaHeight:int = 0;
		private var _preZ:Number = 0;
		
		private const MAX_VISIBLE_Z:int = 0;
		
		public function CommonPhotoStage()
		{
			super();
			
			this.verticalScrollPolicy = "off";
			this.horizontalScrollPolicy = "off";
			
			this.addEventListener(Event.ENTER_FRAME, OnEnterFrame, false, 0, true);
			
			_photoContainer = new Container;
			_photoContainer.verticalScrollPolicy = "off";
			_photoContainer.horizontalScrollPolicy = "off";
			this.addChild(_photoContainer);
			
			_photoR = new Reflector;
			_photoR.target = _photoContainer;
			_photoR.alpha = 0.6;
			_photoR.falloff = 0.5;
			_photoR.blurAmount = 0.3
			this.addChild(_photoR);
		}
		
		public function updateSize(w:int, h:int):void
		{
			_imageAreaWidth = w;
			_imageAreaHeight = h;

			this.width = w;
			this.height = 2 * h;

			PositionPhoto();
		}
		
		public function set newX(val:Number):void
		{
			this.x = val - xPos;
		}
		
		public function set newY(val:Number):void
		{
			this.y = val;
		}
		
		public function set newZ(val:Number):void
		{
			this.z = val;
		}
		
		public function get xPos():int
		{
			if (_photo == null)
			{
				return 0;
			}
			return _photo.x;
		}
		
		public function get hPos():int
		{
			if (_photo == null)
			{
				return 0;
			}
			return _photo.height;
		}
		
		public function get imgWidth():int
		{
			if (_photo == null)
			{
				return 0;
			}
			return _photo.width;
		}
		
		public function get imgHeight():int
		{
			if (_photo == null)
			{
				return 0;
			}
			return _photo.height;
		}
		
		public function set photoInfo(val:BasicPhotoInfo):void
		{
			UpdatePhotoInfo(val);
		}
		
		public function get photoInfo():BasicPhotoInfo
		{
			return _photoInfo;
		}
		
		public function disposePhoto():void
		{
			UnloadPhoto();
		}
		
		private function UpdatePhotoInfo(val:BasicPhotoInfo):void
		{
			if (_photoInfo == null)
			{
				_photoInfo = val;
				InitPhoto();
			}
			else if (val.sourceURL == _photoInfo.sourceURL)
			{
				_photoInfo = val;
				UpdatePhoto();
			}
			else
			{
				UnloadPhoto();
				_photoInfo = val;
				InitPhoto();
			}
		}
		
		private function InitPhoto():void
		{
			if (_photoInfo.data != null)
			{
				CreatePhoto();
			}
			else
			{
				if (_loadPercent == null)
				{
					_loadPercent = new Label;
					_loadPercent.setStyle("fontSize", "36");
					_loadPercent.setStyle("fontWeight", "bold");
					_loadPercent.setStyle("color", "0xFF8000");
					_loadPercent.width = 80;
					_loadPercent.height = 80;
					
					this.addChild(_loadPercent);
				}
				_loadPercent.text = _photoInfo.loadPercent + "%";
			}
		}
		
		private function UpdatePhoto():void
		{
			if (_photoInfo.data == null && _loadPercent != null)
			{
				_loadPercent.text = _photoInfo.loadPercent + "%";
			}
			else if (_photo == null && _loadPercent != null)
			{
				CreatePhoto();
			}
		}
		
		private function UnloadPhoto():void
		{
			if (_photo != null)
			{
				if (_photoContainer.contains(_photo))
				{
					_photoContainer.removeChild(_photo);
				}
				_photo = null
				
				_photoInfo.cleanUp();
				_photoR.invalidateDisplayList();
			}
		}
		
		private function CreatePhoto():void
		{
			if (_loadPercent != null)
			{
				if (this.contains(_loadPercent))
				{
					this.removeChild(_loadPercent);
				}
				_loadPercent = null;
			}
			
			UnloadPhoto();
			var bm:Bitmap = new Bitmap(_photoInfo.data);
			_photo = new Image;
			_photo.source = bm;
			_photoContainer.addChild(_photo);
			
			_photoR.target = _photoContainer;

			PositionPhoto();
			AnimLoadPhoto();
		}

		private function AnimLoadPhoto():void
		{
			if (_photo != null)
			{
				var ty:Number = _photo.y;
				_photo.y += _photo.height;
				Tweener.addTween(_photo, {y: ty, time: 2, transition: "easeOutExpo"});
			}
		}
		
		private function PositionPhoto():void
		{
			if (_photo != null)
			{
				var r:Number = _photoInfo.initWidth / _photoInfo.initHeight;
				
				if (r > _imageAreaWidth / _imageAreaHeight)
				{
					_photo.width = _imageAreaWidth;
					_photo.height = _imageAreaWidth / r;
				}
				else
				{
					_photo.height = _imageAreaHeight;
					_photo.width = _imageAreaHeight *r;
				}
				
				_photo.x = (_imageAreaWidth - _photo.width) *0.5;
				_photo.y = _imageAreaHeight - _photo.height;
			}
			
			// update photocontainer size
			_photoContainer.x = 0;
			_photoContainer.y = 0;
			_photoContainer.width = _imageAreaWidth;
			_photoContainer.height = _imageAreaHeight;
			
			// relocate reflaction --  is this a bug? the relaction class should be put under target automatically
			_photoR.y = _photoContainer.y + _photoContainer.height;
		}
		
		private function OnEnterFrame(e:Event):void
		{
			if (_preZ != this.z)
			{
				if (UpdateVisual(this.z) == true)
				{
					_preZ = this.z;
				}
			}
		}
		
		private function UpdateVisual(val:Number):Boolean
		{
			if (_photo != null)
			{				
				if (val < MAX_VISIBLE_Z)
				{
					_photo.alpha = Math.max(0, (1000 + (val - MAX_VISIBLE_Z)) * 0.001);
				}
				else if (_photo.alpha != 1)
				{
					_photo.alpha = 1;
				}
				
				return true;
			}
			return false;
		}
		
	}
}