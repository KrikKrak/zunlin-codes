package PEUIComponent.TransformToolSource
{
	import flash.events.Event;
	import flash.geom.Point;
	
	public class TransformToolSkewCursor extends TransformToolInternalCursor
	{
		public function TransformToolSkewCursor() {
		}
		
		override public function draw():void {
			super.draw();
			// right arrow
			icon.graphics.moveTo(-6, -1);
			icon.graphics.lineTo(6, -1);
			icon.graphics.lineTo(6, -4);
			icon.graphics.lineTo(10, 1);
			icon.graphics.lineTo(-6, 1);
			icon.graphics.lineTo(-6, -1);
			icon.graphics.endFill();
			
			super.draw();
			// left arrow
			icon.graphics.moveTo(10, 5);
			icon.graphics.lineTo(-2, 5);
			icon.graphics.lineTo(-2, 8);
			icon.graphics.lineTo(-6, 3);
			icon.graphics.lineTo(10, 3);
			icon.graphics.lineTo(10, 5);
			icon.graphics.endFill();
		}
		
		override public function updateVisible(event:Event = null):void {
			super.updateVisible(event);
			if (event) {
				var reference:TransformToolSkewBar = event.target as TransformToolSkewBar;
				if (reference) {
					switch(reference) {
						case _transformTool.skewLeftControl:
						case _transformTool.skewRightControl:
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