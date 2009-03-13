package PEUIComponent.TransformToolSource
{
	import flash.events.Event;
	import flash.geom.Point;
	
	public class TransformToolOutline extends TransformToolInternalControl
	{
		function TransformToolOutline(name:String) {
			super(name);
		}
	
		override public function draw(event:Event = null):void {
			var topLeft:Point = _transformTool.boundsTopLeft;
			var topRight:Point = _transformTool.boundsTopRight;
			var bottomRight:Point = _transformTool.boundsBottomRight;
			var bottomLeft:Point = _transformTool.boundsBottomLeft;
			
			graphics.clear();
			graphics.lineStyle(0, 0);
			graphics.moveTo(topLeft.x, topLeft.y);
			graphics.lineTo(topRight.x, topRight.y);
			graphics.lineTo(bottomRight.x, bottomRight.y);
			graphics.lineTo(bottomLeft.x, bottomLeft.y);
			graphics.lineTo(topLeft.x, topLeft.y);
		}
		
		override public function position(event:Event = null):void {
			draw(event);
		}
	}
}