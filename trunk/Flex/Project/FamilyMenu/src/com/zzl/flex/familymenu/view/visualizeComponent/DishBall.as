package com.zzl.flex.familymenu.view.visualizeComponent
{
	import com.zzl.flex.familymenu.model.DishDetail;
	import com.zzl.flex.familymenu.model.customEvent.VisualDataTargetMouseEvent;
	
	import flash.display.GradientType;
	import flash.display.InterpolationMethod;
	import flash.display.SpreadMethod;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.utils.Timer;


	public class DishBall extends BasicBall
	{
		private var _dish:DishDetail;
		private var _mainTargetMode:Boolean = false;
		private var _minorTargetMode:Boolean = false;
		private var _isDrag:Boolean = false;
		
		private var _oriG:Number = 0;
		
		private var _clickTimer:Timer;

		public function DishBall(size:Number, color:uint, dish:DishDetail = null)
		{
			super(size, color);

			_dish = dish;

			this.addEventListener(MouseEvent.MOUSE_OUT, OnMouseOut, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_OVER, OnMouseOver, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_DOWN, OnMouseDown, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_UP, OnMouseUp, false, 0, true);
			this.addEventListener(MouseEvent.CLICK, OnMouseClick, false, 0, true);
			
			_clickTimer = new Timer(200);
			_clickTimer.addEventListener(TimerEvent.TIMER, OnClickTimer, false, 0, true);
		}

		override protected function DrawSelf():void
		{
			var m:Matrix = new Matrix;
			m.createGradientBox(_size, _size, 0, -_size / 2, -_size / 2);
			g.beginGradientFill(GradientType.RADIAL, [0xFFFFFF, _color], [1, 1], [0, 255], m, SpreadMethod.PAD, InterpolationMethod.RGB, 0.75);
			g.drawCircle(0, 0, _size / 2);
			g.endFill();
		}

		public function traceSelf():void
		{
			trace("DishBall:", _dish.id, "vy:", _vy, "y:", y);
		}
		
		public function get isDraging():Boolean
		{
			return _isDrag;
		}

		public function isBallByID(id:String):Boolean
		{
			return (_dish.id == id);
		}

		public function get dish():DishDetail
		{
			return _dish;
		}

		public function get isMainTarget():Boolean
		{
			return _mainTargetMode;
		}

		public function get isMinorTarget():Boolean
		{
			return _minorTargetMode;
		}

		public function get isTarget():Boolean
		{
			return (_mainTargetMode || _minorTargetMode);
		}

		public function releaseTarget():void
		{
			_mainTargetMode = false;
			_minorTargetMode = false;
		}

		public function activeTarget(mainTarget:Boolean):void
		{
			_mainTargetMode = mainTarget;
			_minorTargetMode = !mainTarget;
		}

		private function OnMouseOver(e:MouseEvent):void
		{
			var ne:VisualDataTargetMouseEvent = new VisualDataTargetMouseEvent(VisualDataTargetMouseEvent.E_VISUAL_DATA_TARGET_MOUSE_OVER);
			dispatchEvent(ne);
		}

		private function OnMouseOut(e:MouseEvent):void
		{
			if (isTarget == false && _isDrag == false)
			{
				_vy += -8;
			}
			
			var ne:VisualDataTargetMouseEvent = new VisualDataTargetMouseEvent(VisualDataTargetMouseEvent.E_VISUAL_DATA_TARGET_MOUSE_OUT);
			dispatchEvent(ne);
		}

		private function OnMouseClick(e:MouseEvent):void
		{
			if (_clickTimer.running == true)
			{
				_clickTimer.stop();
				var ne:VisualDataTargetMouseEvent = new VisualDataTargetMouseEvent(VisualDataTargetMouseEvent.E_VISUAL_DATA_TARGET_MOUSE_CLICK);
				dispatchEvent(ne);
			}
		}
		
		private function OnMouseDown(e:MouseEvent):void
		{
			_oriG = _gravity;
			_gravity = 0;
			_vy = 0;
			_isDrag = true;
			
			this.startDrag();
			_clickTimer.start();
			
			var ne:VisualDataTargetMouseEvent = new VisualDataTargetMouseEvent(VisualDataTargetMouseEvent.E_VISUAL_DATA_TARGET_MOUSE_START_DRAG);
			dispatchEvent(ne);
		}
		
		private function OnMouseUp(e:MouseEvent):void
		{
			_gravity = _oriG;
			_isDrag = false;
			
			this.stopDrag();
			
			var ne:VisualDataTargetMouseEvent = new VisualDataTargetMouseEvent(VisualDataTargetMouseEvent.E_VISUAL_DATA_TARGET_MOUSE_END_DRAG);
			dispatchEvent(ne);
		}
		
		private function OnClickTimer(e:TimerEvent):void
		{
			_clickTimer.stop();
		}
	}
}