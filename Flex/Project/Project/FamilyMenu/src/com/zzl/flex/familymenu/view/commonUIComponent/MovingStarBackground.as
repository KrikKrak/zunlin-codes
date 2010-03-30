package com.zzl.flex.familymenu.view.commonUIComponent
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;

	public class MovingStarBackground extends UIComponent
	{	
		private var _starNumber:int = 1000;
		private var _starSize:int = -1;
		private var _starLight:Number = -1;
		
		private var _running:Boolean = false;
		private var _speed:Number = 1;
		private var _backgrounds:ArrayCollection;
		
		private var _oriWidth:int = 0;
		private var _oriHeight:int = 0;
		
		public function MovingStarBackground(starNumber:int, size:int = -1, light:Number = -1)
		{
			super();
			
			_starNumber = starNumber;
			_starSize = size;
			_starLight = light;
			
			this.addEventListener(FlexEvent.CREATION_COMPLETE, OnCreationComplete, false, 0, true);
			this.addEventListener(ResizeEvent.RESIZE, OnResize, false, 0, true);
			this.addEventListener(Event.ENTER_FRAME, OnEnterFrame, false, 0, true);
		}
		
		public function set running(val:Boolean):void
		{
			_running = val;
		}
		
		public function get running():Boolean
		{
			return _running;
		}
		
		public function set speed(val:Number):void
		{
			_speed = val;
		}
		
		public function get speed():Number
		{
			return _speed;
		}
		
		private function OnCreationComplete(e:FlexEvent):void
		{
			CreateBackground();
		}
		
		private function OnResize(e:ResizeEvent):void
		{
			if ((this.width != _oriWidth || this.height != _oriHeight) && _backgrounds != null && _backgrounds.length != 0)
			{
				var r:Boolean = _running;
				_running = false;
				CreateBackground();
				_running = r;
			}
		}
		
		private function OnEnterFrame(e:Event):void
		{
			if (_running == true)
			{
				for each (var b:StarBackground in _backgrounds)
				{
					b.x += speed;
					if (this.width - b.x < 1)
					{
						b.x = -this.width;
					}
				}
			}
		}
		
		private function CreateBackground():void
		{
			RemoveBackground()

			_oriWidth = this.width;
			_oriHeight = this.height;
			
			// create 2 star backgrounds
			var sbg1:StarBackground = new StarBackground(_starNumber, _starSize, _starLight);
			sbg1.width = this.width;
			sbg1.height = this.height;
			
			var sbg2:StarBackground = new StarBackground(_starNumber, _starSize, _starLight);
			sbg2.width = this.width;
			sbg2.height = this.height;
			
			_backgrounds = new ArrayCollection;
			_backgrounds.addItem(sbg1);
			_backgrounds.addItem(sbg2);

			this.addChild(sbg1);
			sbg1.x = 0;
			sbg1.y = 0;
			
			this.addChild(sbg2);
			sbg2.x = -this.width;
			sbg2.y = 0;
		}
		
		private function RemoveBackground():void
		{
			if (_backgrounds == null)
			{
				return;
			}
			
			for each (var b:StarBackground in _backgrounds)
			{
				if (this.contains(b))
				{
					this.removeChild(b);
				}
				b == null;
			}
			_backgrounds.removeAll();
			_backgrounds = null;
		}
		
	}
}