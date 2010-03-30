package PEUIComponent.TransformToolSource
{
	import flash.events.Event;
	import flash.geom.Point;
	
	public class TransformToolScaleCursor extends TransformToolInternalCursor
	{
		public function TransformToolScaleCursor() {
		}
		
		override public function draw():void {
			super.draw();
			// right arrow
			icon.graphics.moveTo(4.5, -0.5);
			icon.graphics.lineTo(4.5, -2.5);
			icon.graphics.lineTo(8.5, 0.5);
			icon.graphics.lineTo(4.5, 3.5);
			icon.graphics.lineTo(4.5, 1.5);
			icon.graphics.lineTo(-0.5, 1.5);
			// left arrow
			icon.graphics.lineTo(-3.5, 1.5);
			icon.graphics.lineTo(-3.5, 3.5);
			icon.graphics.lineTo(-7.5, 0.5);
			icon.graphics.lineTo(-3.5, -2.5);
			icon.graphics.lineTo(-3.5, -0.5);
			icon.graphics.lineTo(4.5, -0.5);
			icon.graphics.endFill();
		}
		
		override public function updateVisible(event:Event = null):void {
			super.updateVisible(event);
			if (event) {
				var reference:TransformToolScaleControl = event.target as TransformToolScaleControl;
				if (reference) {
					switch(reference) {
						case _transformTool.scaleTopLeftControl:
						case _transformTool.scaleBottomRightControl:
							icon.rotation = (getGlobalAngle(new Point(0,100)) + getGlobalAngle(new Point(100,0)))/2;
							break;
						case _transformTool.scaleTopRightControl:
						case _transformTool.scaleBottomLeftControl:
							icon.rotation = (getGlobalAngle(new Point(0,-100)) + getGlobalAngle(new Point(100,0)))/2;
							break;
						case _transformTool.scaleTopControl:
						case _transformTool.scaleBottomControl:
							icon.rotation = getGlobalAngle(new Point(0,100));
							break;
						default:
							icon.rotation = getGlobalAngle(new Point(100,0));
					}
				}
			}
		}
	}
}