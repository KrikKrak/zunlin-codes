package com.zzl.flex.uitool
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.filters.BlurFilter;
	
	public class UITools
	{
		public function UITools()
		{
		}
		
		public static var spotlight:Object = {depth: 50};
		public static function createSpotlightBitmap(w:int, h:int):Bitmap
		{
			var circleDim:int = Math.max(w, h);
			var sl:Sprite = new Sprite;
			
			var fillType:String = GradientType.RADIAL;
			var colors:Array = [0xFF000000, 0xFF300000];
			var alphas:Array = [1, 1];
			var ratios:Array = [spotlight.depth, 255];
			var matrix:Matrix = new Matrix;
			matrix.createGradientBox(circleDim, circleDim, 0, 0, 0);
			
			sl.graphics.beginGradientFill(fillType, colors, alphas, ratios, matrix);
			sl.graphics.moveTo(0, 0);
			sl.graphics.lineTo(0, circleDim);
			sl.graphics.lineTo(circleDim, circleDim);
			sl.graphics.lineTo(circleDim, 0);
			sl.graphics.lineTo(0, 0);
			sl.graphics.endFill();
			
			var alphaBmp:BitmapData = new BitmapData(w, h, true, colors[1]);
			matrix = new Matrix;
			matrix.translate((w - circleDim) / 2, (h - circleDim) / 2);
			alphaBmp.draw(sl, matrix);
			var filter:BlurFilter = new BlurFilter(32, 32, 3);
			alphaBmp.applyFilter(alphaBmp, alphaBmp.rect, new Point(0, 0), filter);
			
			var maskBmp:BitmapData = new BitmapData(w, h, true, 0xFF000000);
			maskBmp.copyChannel(alphaBmp, alphaBmp.rect, new Point(0, 0), BitmapDataChannel.RED, BitmapDataChannel.ALPHA);

			var bp:Bitmap = new Bitmap(maskBmp);
			return bp;
		}

	}
}