package PEUIComponent
{
	import mx.containers.Canvas;

	public class DragPanel extends Canvas
									implements IDragPanel
	{
		public function DragPanel()
		{
			super();
		}
		
		public function get moveable():Boolean
		{
			return true;
		}
		
		public function IsMouseOver(mx:Number, my:Number):Boolean
		{
			return this.hitTestPoint(mx, my, false);
		}
		
		public function CanDrag(mx:Number, my:Number):Boolean
		{
			return true;
		}
		
		public function ChangDragPos(xOffset:Number, yOffset:Number):void
		{
			this.x += xOffset;
			this.y += yOffset;
		}
		
	}
}