package com.zzl.flex.photoGallery.view.viewStage
{
	import com.zzl.flex.photoGallery.view.photoStage.CommonPhotoStage;
	
	import flash.events.Event;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	
	public class SpacePhotoView extends CommonViewStage
	{
		protected var BORDER_GAP:int = -100;
		protected var EASING_VALUE:Number = 0.15;
		
		private var _preChildrenNum:int = 0;
		private var _preStageZ:Number = 0;
		
		private var _initChildrenPosition:ArrayCollection;
		
		public function SpacePhotoView()
		{
			super();
			
			PHOTO_WIDTH = 320;
			PHOTO_HEIGHT = 320;
		}
		
		override protected function ConsInit():void
		{
			super.ConsInit();
			
			_mainStage.verticalScrollPolicy = "off";
			_mainStage.horizontalScrollPolicy = "off";
			
			_initChildrenPosition = new ArrayCollection;
			
			this.addEventListener(Event.ENTER_FRAME, OnEnterFrame, false, 0, true);
		}
		
		override protected function RemovePhotos():void
		{
			_preChildrenNum = 0;
			_preStageZ = 0;
			_modelLocator.projectionDistance = 0;
			
			super.RemovePhotos();
		}
		
		override protected function UpdatePhotoPosition():void
		{
			if (_preChildrenNum != _photoChildren.length)
			{
				SortChildren();
				_preChildrenNum = _photoChildren.length;
				_preStageZ = 0;
				_modelLocator.projectionDistance = 0;
			
				_initChildrenPosition.removeAll();
				
				var i:int = 0;		
				for each (var pc:CommonPhotoStage in _photoChildren)
				{
					pc.x = GetRandomXPos((i % 2 == 0), PHOTO_WIDTH);
					pc.y = this.height * 0.1;
					pc.z = (i == 0) ? 50 : i * 500;

					_initChildrenPosition.addItem({x:pc.x, y:pc.y, z:pc.z, nextZ:0});
					++i;
				}
			}
		}
		
		override public function updateViewCenter(p:Point):void
		{
			return;
		}
		
		override public function updateViewDistance(n:Number):void
		{
			return;
		}
		
		protected function SortChildren():void
		{
			var i:int = 0;
			var l:int = _photoChildren.length;
			for each (var pc:CommonPhotoStage in _photoChildren)
			{
				_mainStage.setChildIndex(pc, l - 1 - i);
				++i;
			}
		}
		
		protected function OnEnterFrame(e:Event):void
		{
			if (this.transform == null)
			{
				return;
			}
			
			if (this.transform.perspectiveProjection == null)
			{
				var p:PerspectiveProjection = new PerspectiveProjection;
				p.projectionCenter = new Point(this.width / 2, this.height / 4);
				p.focalLength = 300;
				this.transform.perspectiveProjection = p;
			}
			
			if (_modelLocator.projectionCenter != null)
			{
				var np:Point = LimitCenterPoint(_modelLocator.projectionCenter.x, _modelLocator.projectionCenter.y);
				var pp:PerspectiveProjection = this.transform.perspectiveProjection;
				if (pp.projectionCenter.x != np.x || pp.projectionCenter.y != np.y)
				{
					var vx:Number = (np.x - pp.projectionCenter.x) * EASING_VALUE;
					var vy:Number = (np.y - pp.projectionCenter.y) * EASING_VALUE;
					pp.projectionCenter = new Point(pp.projectionCenter.x + vx, pp.projectionCenter.y + vy);
					this.transform.perspectiveProjection = pp;
				}
			}

			if (_preStageZ != _modelLocator.projectionDistance)
			{
				for (var i:int = 0; i < _initChildrenPosition.length; ++i)
				{
					_initChildrenPosition[i].nextZ = _initChildrenPosition[i].z - _modelLocator.projectionDistance;
				}
				_preStageZ = _modelLocator.projectionDistance;
			}
				
			if (_preStageZ != 0)
			{
				i = 0;
				for each (var pc:CommonPhotoStage in _photoChildren)
				{
					pc.z += (_initChildrenPosition[i].nextZ - pc.z) * EASING_VALUE;
					++i;
				}
			}
		}
		
		private function LimitCenterPoint(x:int, y:int):Point
		{
			var cx:int = this.width *0.5;
			var cy:int = this.height * 0.5;
			
			return new Point(cx + (x - cx) / 2, cy + (y - cy) / 3 - 100);
		}
		
		private function GetRandomXPos(atLeft:Boolean, iw:Number):Number
		{
			if (atLeft == true)
			{
				return Math.random() * (0.75 * this.width - iw - BORDER_GAP) + BORDER_GAP;
			}
			else
			{
				return Math.random() * (0.75 * this.width - iw - BORDER_GAP) + 0.25 * this.width;
			}
		}
		
	}
}