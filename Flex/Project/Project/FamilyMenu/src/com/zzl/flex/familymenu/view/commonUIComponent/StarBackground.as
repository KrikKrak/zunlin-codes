package com.zzl.flex.familymenu.view.commonUIComponent
{
	import com.zzl.flex.algorithm.CommonTools;
	
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;

	public class StarBackground extends UIComponent
	{
		private var _starNumber:int = 1000;
		private var _starSize:int = -1;
		private var _starLight:Number = -1;
		
		private const MAX_STAR_SIZE:int = 15;
		private const MIN_STAR_LIGHT:Number = 0.8;
		
		public function StarBackground(starNumber:int, size:int = -1, light:Number = -1)
		{
			super();
			
			_starNumber = Math.max(1, Math.min(starNumber, 1000));
			_starSize = (size == -1) ? -1 : Math.max(1, Math.min(size, 20));
			_starLight = (light == -1) ? -1 : Math.max(MIN_STAR_LIGHT, Math.min(light, 1));
			
			this.addEventListener(ResizeEvent.RESIZE, OnContainerResize, false, 0, true);
			this.addEventListener(FlexEvent.CREATION_COMPLETE, OnContainerComplete, false, 0, true);
		}
		
		public function drawBackground():void
		{
			this.graphics.clear();
			for (var i:int = 0; i < _starNumber; ++i)
			{
				var rx:int = Math.random() * this.width;
				var ry:int = Math.random() * this.height;
				var rs:int = (_starSize == -1) ? Math.random() * MAX_STAR_SIZE : _starSize;
				var rl:Number = (_starLight == -1) ? Math.random() * (1 - MIN_STAR_LIGHT) + MIN_STAR_LIGHT : _starLight;
				DrawStar(this, rx, ry, rs, rl);
			}
		}
		
		private function DrawStar(s:Sprite, x:int, y:int, size:Number = 10, light:Number = 1):void
		{
			if (s != null)
			{
				size = Math.max(3, Math.min(size, 12));
				light = Math.max(0.5, Math.min(light, 1));
				var g:Graphics = s.graphics;
				var colors:Array = [CommonTools.grayValueAdjust(0xFFFFFF, light), 0xFFFFFF];
				var alphas:Array = [1, 0];
				var ratios:Array = [0, 255];
				var matr:Matrix = new Matrix();
				matr.createGradientBox(size, size, 0, x, y);

				g.beginGradientFill(GradientType.RADIAL, colors, alphas, ratios, matr);
				g.drawRect(x, y, size, size);
				g.endFill();
			}
		}
		
		private function OnContainerComplete(e:FlexEvent):void
		{
			drawBackground();
		}
		
		private function OnContainerResize(e:ResizeEvent):void
		{
			drawBackground();
		}
	}
}