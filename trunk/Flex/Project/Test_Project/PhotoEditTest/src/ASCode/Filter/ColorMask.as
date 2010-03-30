package ASCode.Filter
{
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class ColorMask
	{
		/**
		* This number define the distence of the edge to the non-transparent part in mask.
		* For example, this circle mask size is 10, if the number is 0.2, we make size 2 of the
		* make to transparent gradient.
		*/		
		private var _transparentLength:Number = 0.2;
		private var _maxTranparentPercent:Number = 0.3;
		
		private var _data:BitmapData;
		private var _maskColor:uint = 0xffffffff;
		
		public function ColorMask(data:BitmapData)
		{
			_data = data;
		}
		
		public function set maskColor(val:uint):void
		{
			_maskColor = val;
		}
		
		public function setMaskColor(val:uint, trans:Number = 0.3):void
		{
			_maxTranparentPercent = trans;
			_maskColor = val;
		}
		
		public function drawCircle(px:Number, py:Number, r:Number):void
		{
			trace("drawCircle", px, py, r);
			
			var m:Matrix = new Matrix;
			m.createGradientBox(r * 2, r * 2, 0, px - r, py - r);
			
			var _maskGraphics:Sprite = new Sprite();
			_maskGraphics.graphics.beginGradientFill(	GradientType.RADIAL,
																	[_maskColor, 0xffffff],
																	[_maxTranparentPercent, 0],
																	[255 * (1 - _transparentLength), 255],
																	m);
			_maskGraphics.graphics.drawCircle(px, py, r);
			_maskGraphics.graphics.endFill();
			
			_data.draw(_maskGraphics);
			var maxColor:uint = (0xFF * _maxTranparentPercent << 24) + 0xffffff;
			_data.threshold(	_data,
									new Rectangle(0, 0, _data.width, _data.height),
									new Point(0, 0),
									">", maxColor, maxColor, 0xFF000000);
		}
		
		public function eraseCircle(px:Number, py:Number, r:Number):void
		{
			trace("eraseCircle", px, py, r);
			
			_data.threshold(	_data,
									new Rectangle(px - r, py - r, r * 2, r * 2),
									new Point(px - r, py - r),
									">", 0x00000000, 0x00000000, 0xFF000000);
		}
		
		public function eraseRect(px:Number, py:Number, w:Number, h:Number):void
		{
			trace("earseRect", px, py, w, h);
			
			_data.threshold(	_data,
									new Rectangle(px, py, w, h),
									new Point(px, py),
									">", 0x00000000, 0x00000000, 0xFF000000);
		}
		
		public function mergeMask(source:BitmapData):void
		{
			// check if mask exist
			var newMask:BitmapData = _data.clone();
			var count:uint = newMask.threshold(	newMask,
																new Rectangle(0, 0, newMask.width, newMask.height),
																new Point(0, 0),
																">", 0x00ffffff, 0xffffffff, 0xFF000000);
			newMask.dispose();
			if (count == 0)
			{
				return;
			}
			
			// save source if we need undo function;
			SaveSourceData(source);
			source.draw(_data);
		}
		
		private function SaveSourceData(source:BitmapData):void
		{
			return;
		}

	}
}