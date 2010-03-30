package PEUIComponent.TransformToolSource
{
	import flash.events.Event;
	
	public class TransformToolRegistrationControl extends TransformToolInternalControl
	{
		function TransformToolRegistrationControl(name:String, interactionMethod:Function, referenceName:String) {
			super(name, interactionMethod, referenceName);
		}
	
		override public function draw(event:Event = null):void {
			graphics.clear();
			if (!_skin) {
				graphics.lineStyle(1, 0);
				graphics.beginFill(0xFFFFFF);
				graphics.drawCircle(0, 0, _transformTool.controlSize/2);
				graphics.endFill();
			}
			super.draw();
		}
	}
}