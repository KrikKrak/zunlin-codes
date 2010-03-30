package com.Roxio.PhotoStar.Algorithm.PhotoAdjust
{
	import com.Roxio.PhotoStar.UI.EditPanel.ImageHolder;
	
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	
	public class StraightenPanel extends Canvas
											implements IOverAdjustPanel
	{
		private static var _inst:StraightenPanel = null;
		private var _alg:StraightenAlgorithm = null;
		private var _data:ImageHolder;
		
		private var _mouseDown:Boolean = false;
		private var _curMousePos:Array = new Array(2);
		
		public function StraightenPanel()
		{
			super();
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, OnMouseDown, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_MOVE, OnMouseMove, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_UP, OnMouseUp, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_OUT, OnMouseOut, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_OVER, OnMouseOver, false, 0, true);
		}
	
		public static function inst():StraightenPanel
		{
			if (_inst == null)
			{
				_inst = new StraightenPanel;
			}
			_inst.CreateAlgorithm();
			return _inst;
		}
		
		public function set straightenData(data:ImageHolder):void
		{
			_alg.data = data;
			_data = data;
			
			updatePanelSize();
		}
		
		public function done():void
		{
			_alg.execute();
		}
		
		public function cancel():void
		{
			_alg.cancel();
		}
		
		private function CreateAlgorithm():void
		{
			_alg = new StraightenAlgorithm;
		}
		
		private function Rotate():void
		{
			if (_curMousePos[1] == this.mouseY || _curMousePos[0] == this.mouseX)
			{
				return;
			}
			
			var angle:Number;
			if (_curMousePos[0] < this.mouseX)
			{
				angle = Math.atan((this.mouseY - _curMousePos[1]) / (this.mouseX - _curMousePos[0]));
			}
			else
			{
				angle = Math.atan((_curMousePos[1] - this.mouseY) / (_curMousePos[0] - this.mouseX));
			}
			_alg.test(-angle);
			updatePanelSize();
		}
		
		public function updatePanelSize():void
		{
			var rect:Rectangle = _data.dataGlobalRect;
			this.x = 0;
			this.y = 0;
			var lStartPos:Point = this.globalToLocal(new Point(rect.x, rect.y));
			this.x = lStartPos.x;
			this.y = lStartPos.y;
			this.width = rect.width;
			this.height = rect.height;
		}
		
		private function OnMouseDown(event:MouseEvent):void
		{
			_mouseDown = true;
			UpdateMousePos();
		}
		
		private function OnMouseMove(event:MouseEvent):void
		{
			if (_mouseDown == true && event.buttonDown == true)
			{
				var g:Graphics = graphics;
		    	g.clear();
		    	
				var lineColor:uint =  0xFF8000;
				var lineThickness:Number = 3;
            
		    	g.lineStyle(lineThickness, lineColor, 1);
				g.moveTo(_curMousePos[0], _curMousePos[1]);
				g.lineTo(this.mouseX, this.mouseY);
			}
		}
		
		private function OnMouseUp(event:MouseEvent):void
		{
			if (_mouseDown == true)
			{
				var g:Graphics = graphics;
		    	g.clear();
		    	
				_mouseDown = false;
				Rotate();
			}
		}
		
		private function OnMouseOut(event:MouseEvent):void
		{
			/* if (_mouseDown == true)
			{
				var g:Graphics = graphics;
		    	g.clear();
			} */
		}
		
		private function OnMouseOver(event:MouseEvent):void
		{
			if (event.buttonDown == false && _mouseDown == true)
			{
				var g:Graphics = graphics;
		    	g.clear();
		    	_mouseDown = false;
			}
		}
		
		private function UpdateMousePos():void
		{
			_curMousePos[0] = this.mouseX;
			_curMousePos[1] = this.mouseY;
		}
		
	}
}