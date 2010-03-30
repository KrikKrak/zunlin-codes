package ASCode
{
	import mx.core.UIComponent;
	import flash.display.Graphics;

	public class ShapeContainer extends UIComponent
	{
		public function ShapeContainer()
		{
			super();
		}
		
		public function DrawRect():void
		{
			var g:Graphics = graphics;
			g.beginFill(0xFF8000);
			g.drawRect(GetRandomNumber(10, this.width - 10),
							GetRandomNumber(10, this.height - 10),
							GetRandomNumber(1, 20),
							GetRandomNumber(1, 20));
			g.endFill();
		}
		
		public function DrawCircle():void
		{
			var g:Graphics = graphics;
			g.beginFill(0xFF8000);
			g.drawCircle(GetRandomNumber(10, this.width - 10),
							GetRandomNumber(10, this.height - 10),
							GetRandomNumber(1, 20));
			g.endFill();
		}
		
		private function GetRandomNumber(n1:Number, n2:Number):Number
        {
        	if (n1 == n2)
        	{
        		return n1;
        	}

        	var ran:Number = Math.random();
        	var minNu:Number = 0;
        	if (n1 < n2)
        	{
        		minNu = n1;
        	}
        	else
        	{
        		minNu = n2;
        	}
        	return minNu + ran * Math.abs(n1 - n2);
        }
		
	}
}