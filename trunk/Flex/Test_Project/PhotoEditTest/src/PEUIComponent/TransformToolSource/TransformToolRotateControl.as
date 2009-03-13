package PEUIComponent.TransformToolSource
{
	import flash.events.Event;
	import flash.geom.Point;
	
	public class TransformToolRotateControl extends TransformToolInternalControl
	{
		private var locationName:String;
	
		function TransformToolRotateControl(name:String, interactionMethod:Function, locationName:String) {
			super(name, interactionMethod);
			this.locationName = locationName;
		}
	
		override public function draw(event:Event = null):void {
			graphics.clear();
			if (!_skin) {
				graphics.beginFill(0xFF, 0);
				graphics.drawCircle(0, 0, _transformTool.controlSize*2);
				graphics.endFill();
			}
			super.draw();
		}
		
		override public function position(event:Event = null):void {
			if (locationName in _transformTool) {
				var location:Point = _transformTool[locationName];
				x = location.x;
				y = location.y;
			}
		}
	}
}