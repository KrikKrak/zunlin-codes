package PEUIComponent.TransformToolSource
{
	import flash.events.Event;
	
	public class TransformToolScaleControl extends TransformToolInternalControl
	{
		function TransformToolScaleControl(name:String, interactionMethod:Function, referenceName:String) {
		super(name, interactionMethod, referenceName);
		}
	
		override public function draw(event:Event = null):void {
			graphics.clear();
			if (!_skin) {
				graphics.lineStyle(2, 0xFFFFFF);
				graphics.beginFill(0);
				var size:Number = _transformTool.controlSize;
				var size2:Number = size/2;
				graphics.drawRect(-size2, -size2, size, size);
				graphics.endFill();
			}
			super.draw();
		}
	}
}