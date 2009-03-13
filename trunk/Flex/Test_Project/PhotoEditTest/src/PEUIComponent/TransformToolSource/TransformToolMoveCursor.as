package PEUIComponent.TransformToolSource
{
	public class TransformToolMoveCursor extends TransformToolInternalCursor
	{
		public function TransformToolMoveCursor() {
		}
		
		override public function draw():void {
			super.draw();
			// up arrow
			icon.graphics.moveTo(1, 1);
			icon.graphics.lineTo(1, -2);
			icon.graphics.lineTo(-1, -2);
			icon.graphics.lineTo(2, -6);
			icon.graphics.lineTo(5, -2);
			icon.graphics.lineTo(3, -2);
			icon.graphics.lineTo(3, 1);
			// right arrow
			icon.graphics.lineTo(6, 1);
			icon.graphics.lineTo(6, -1);
			icon.graphics.lineTo(10, 2);
			icon.graphics.lineTo(6, 5);
			icon.graphics.lineTo(6, 3);
			icon.graphics.lineTo(3, 3);
			// down arrow
			icon.graphics.lineTo(3, 5);
			icon.graphics.lineTo(3, 6);
			icon.graphics.lineTo(5, 6);
			icon.graphics.lineTo(2, 10);
			icon.graphics.lineTo(-1, 6);
			icon.graphics.lineTo(1, 6);
			icon.graphics.lineTo(1, 5);
			// left arrow
			icon.graphics.lineTo(1, 3);
			icon.graphics.lineTo(-2, 3);
			icon.graphics.lineTo(-2, 5);
			icon.graphics.lineTo(-6, 2);
			icon.graphics.lineTo(-2, -1);
			icon.graphics.lineTo(-2, 1);
			icon.graphics.lineTo(1, 1);
			icon.graphics.endFill();
		}
	}
}