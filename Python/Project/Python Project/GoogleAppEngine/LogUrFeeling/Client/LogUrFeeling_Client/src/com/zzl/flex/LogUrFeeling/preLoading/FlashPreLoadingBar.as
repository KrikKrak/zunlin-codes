package com.zzl.flex.LogUrFeeling.preLoading
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	import mx.events.FlexEvent;
	import mx.preloaders.DownloadProgressBar;

	public class FlashPreLoadingBar extends DownloadProgressBar
	{
		private var cp:CustomPreloader;
		
		public function FlashPreLoadingBar()
		{
			super();
			Init();
		}
		
		private function Init():void
		{
			cp = new CustomPreloader;
			this.addEventListener(Event.ADDED_TO_STAGE, OnComponentAdded, false, 0, true);
			this.addChild(cp);
		}
		
		private function OnComponentAdded(e:Event):void
		{
			cp.gotoAndStop(1);
			cp.x = stage.stageWidth * 0.5 - 135;
			cp.y = stage.stageHeight * 0.5 - 34;
		}
		
		override public function set preloader(value:Sprite):void
		{
			value.addEventListener(ProgressEvent.PROGRESS, OnProgress, false, 0, true);
			value.addEventListener(FlexEvent.INIT_COMPLETE, OnComplete, false, 0, true);
		}
		
		private function OnProgress(e:ProgressEvent):void
		{
			var p:int = int(e.bytesLoaded / e.bytesTotal * 100);
			cp.percent.text = p.toString() + "%";
			cp.gotoAndStop(p);
		}
		
		private function OnComplete(e:FlexEvent):void
		{
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
	}
}