package com.zzl.flex.LogUrFeeling.preLoading
{
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.text.TextField;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.preloaders.DownloadProgressBar;

	public class LogUrFeelingPreLoading extends DownloadProgressBar
	{
		private var _percentBar:MovieClip;
		private var _percentText:TextField;
		
		private const SINGLE_PERCENT_WIDTH:int = 4;
		private const SINGLE_PERCENT_HEIGHT:int = 20;
		private const INIT_COLOR:int = 0xFF0000;
		private const LOAD_COLOR:int = 0x00FF00;
		
		public function LogUrFeelingPreLoading()
		{
			super();
			Init();
		}
		
		private function Init():void
		{
			_percentBar = new MovieClip;
			_percentBar.width = 100 * 2 * SINGLE_PERCENT_WIDTH;
			_percentBar.height = SINGLE_PERCENT_HEIGHT;
			
			this.addChild(_percentBar);
			
			_percentText = new TextField;
			_percentText.width = 200;
			_percentText.height = 20;
			
			this.addChild(_percentText);
		}
		
		override public function set preloader(preloader:Sprite):void
		{
			preloader.addEventListener(ProgressEvent.PROGRESS, OnProgress, false, 0, true);
			preloader.addEventListener(Event.COMPLETE, OnComplete, false, 0, true);
			preloader.addEventListener(FlexEvent.INIT_PROGRESS, OnInitProgress, false, 0, true);
			preloader.addEventListener(FlexEvent.INIT_COMPLETE, OnInitComplete, false, 0, true);
		}
		
		private function OnProgress(e:ProgressEvent):void
		{
			DrawPercent(int(e.bytesLoaded / e.bytesTotal * 100), LOAD_COLOR);
			trace("---------");
			_percentText.appendText(int(e.bytesLoaded / e.bytesTotal * 100).toString());
		}
		
		private function OnComplete(e:Event):void
		{
			DrawPercent(100, LOAD_COLOR);
		}
		
		private function OnInitProgress(e:FlexEvent):void
		{
			DrawPercent(50, INIT_COLOR);
		}
		
		private function OnInitComplete(e:FlexEvent):void
		{
			DrawPercent(100, INIT_COLOR);
		}
		
		private function DrawPercent(percent:int, color:int):void
		{
			if (_percentBar != null)
			{
				var g:Graphics = _percentBar.graphics;
				g.clear();
				g.beginFill(color);
				for (var i:int = 0; i < percent; ++i)
				{
					g.drawRect(i * 2 * SINGLE_PERCENT_WIDTH, 0, SINGLE_PERCENT_WIDTH, SINGLE_PERCENT_HEIGHT);
				}
				g.endFill();
			}
		}
	}
}