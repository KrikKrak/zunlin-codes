package com.zzl.flex.familymenu.view.visualizeComponent
{
	import com.zzl.flex.familymenu.model.DishDetail;
	import com.zzl.flex.familymenu.model.customEvent.VisualDataTargetPickEvent;
	
	import flash.display.GradientType;
	import flash.display.InterpolationMethod;
	import flash.display.SpreadMethod;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	
	public class DishBall extends BasicBall
	{
		private var _dish:DishDetail;
		private var _targetMode:Boolean = false;
		
		public function DishBall(size:Number, color:uint, dish:DishDetail = null)
		{
			super(size, color);
			
			_dish = dish;
			
			this.addEventListener(MouseEvent.MOUSE_OUT, OnMouseOut, false, 0, true);
			this.addEventListener(MouseEvent.CLICK, OnMouseClick, false, 0, true);
		}
		
		override protected function DrawSelf():void
		{
			var m:Matrix = new Matrix;
			m.createGradientBox(_size, _size, 0, -_size / 2, -_size / 2);
			g.beginGradientFill(GradientType.RADIAL, [0xFFFFFF, _color], [1, 1], [0, 255], m, SpreadMethod.PAD, InterpolationMethod.RGB, 0.75);
			g.drawCircle(0, 0, _size / 2);
			g.endFill();
		}
		
		public function get dish():DishDetail
		{
			return _dish;
		}
		
		public function releaseTarget():void
		{
			_targetMode = false;
		}
		
		public function activeTarget():void
		{
			
		}
		
		private function OnMouseOut(e:MouseEvent):void
		{
			if (_targetMode == false)
			{
				_vy += -8;
			}
		}
		
		private function OnMouseClick(e:MouseEvent):void
		{
			_targetMode = true;
			var ne:VisualDataTargetPickEvent = new VisualDataTargetPickEvent(VisualDataTargetPickEvent.E_VISUAL_DATA_TARGET_PICK);
			dispatchEvent(ne);
		}
	}
}