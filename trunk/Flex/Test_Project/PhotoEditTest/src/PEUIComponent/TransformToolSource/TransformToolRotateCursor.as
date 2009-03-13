package PEUIComponent.TransformToolSource
{
	public class TransformToolRotateCursor extends TransformToolInternalCursor
	{
		public function TransformToolRotateCursor() {
		}
		
		override public function draw():void {
			super.draw();
			// curve
			var angle1:Number = Math.PI;
			var angle2:Number = -Math.PI/2;
			drawArc(0,0,4, angle1, angle2);
			drawArc(0,0,6, angle2, angle1, false);
			// arrow
			icon.graphics.lineTo(-8, 0);
			icon.graphics.lineTo(-5, 4);
			icon.graphics.lineTo(-2, 0);
			icon.graphics.lineTo(-4, 0);
			icon.graphics.endFill();
		}
	}
}