package PEUIComponent
{
	import ASCode.PhotoAdjust.StraightenAlgorithm;
	import ASCode.PhotoEditBitmap;
	
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.events.MouseEvent;
	
	public class StraightenPanel extends DragPanel
	{
		private static var inst:StraightenPanel = null;
		private var alg:StraightenAlgorithm = null;
		private var picData:PhotoEditBitmap;
		
		private var mouseDown:Boolean = false;
		private var downPos:Array = new Array(2);
		
		public function StraightenPanel()
		{
			super();
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, OnMouseDown, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_MOVE, OnMouseMove, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_UP, OnMouseUp, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_OUT, OnMouseOut, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_OVER, OnMouseOver, false, 0, true);
		}
	
		public static function GetStraightenPanel():StraightenPanel
		{
			if (inst == null)
			{
				inst = new StraightenPanel;
			}
			inst.CreateAlgorithm();
			return inst;
		}
		
		public function SetBitmap(data:PhotoEditBitmap):void
		{
			alg.data = data;
			picData = data;
		}
		
		public function StraightenDone():void
		{
			alg.Execute();
		}
		
		public function StraightenCancel():void
		{
			alg.Cancel();
		}
		
		private function CreateAlgorithm():void
		{
			alg = new StraightenAlgorithm;
		}
		
		private function Rotate():void
		{
			if (downPos[1] == this.mouseY || downPos[0] == this.mouseX)
			{
				return;
			}
			
			var angle:Number;
			if (downPos[0] < this.mouseX)
			{
				angle = Math.atan((this.mouseY - downPos[1]) / (this.mouseX - downPos[0]));
			}
			else
			{
				angle = Math.atan((downPos[1] - this.mouseY) / (downPos[0] - this.mouseX));
			}
			alg.Test(-angle);
			DataSizeChange();
		}
		
		override public function IsMouseOver(mx:Number, my:Number):Boolean
		{
			trace("IsMouseOver");
			if (this.mouseX >= 0 && this.mouseX <= this.width && this.mouseY >= 0 && this.mouseY <= this.height)
			{
				return true;
			}
			return false;
		}
		
		override public function get moveable():Boolean
		{
			return false;
		}
		
		override public function CanDrag(mx:Number, my:Number):Boolean
		{
			// if in this mode, no drag at all
			return false;
		}
		
		override public function ChangDragPos(xOffset:Number, yOffset:Number):void
		{
			return;
		}
		
		public function DataSizeChange():void
		{
			var rect:Rectangle = picData.dataGlobalRect;
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
			trace("OnMouseDown");
			mouseDown = true;
			SaveMousePos();
		}
		
		private function OnMouseMove(event:MouseEvent):void
		{
			if (mouseDown == true && event.buttonDown == true)
			{
				var g:Graphics = graphics;
		    	g.clear();
		    	
				var lineColor:uint =  0xFF8000;
				var lineThickness:Number = 3;
            
		    	g.lineStyle(lineThickness, lineColor, 1);
				g.moveTo(downPos[0], downPos[1]);
				g.lineTo(this.mouseX, this.mouseY);
			}
		}
		
		private function OnMouseUp(event:MouseEvent):void
		{
			if (mouseDown == true)
			{
				var g:Graphics = graphics;
		    	g.clear();
		    	
				mouseDown = false;
				Rotate();
			}
		}
		
		private function OnMouseOut(event:MouseEvent):void
		{
			
		}
		
		private function OnMouseOver(event:MouseEvent):void
		{
			if (event.buttonDown == false && mouseDown == true)
			{
				var g:Graphics = graphics;
		    	g.clear();
		    	mouseDown = false;
			}
		}
		
		private function SaveMousePos():void
		{
			downPos[0] = this.mouseX;
			downPos[1] = this.mouseY;
		}
		
	}
}