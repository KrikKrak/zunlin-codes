package PEUIComponent.TransformToolSource
{
	public class TransformToolRegistrationCursor extends TransformToolInternalCursor
	{
		public function TransformToolRegistrationCursor() {
		}
		
		override public function draw():void {
			super.draw();
			icon.graphics.drawCircle(0,0,2);
			icon.graphics.drawCircle(0,0,4);
			icon.graphics.endFill();
		}
	}
}