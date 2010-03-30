package com.zzl.flex.familymenu.view.visualizeComponent
{
	import com.zzl.flex.familymenu.view.SimpleDishInfoPanel;
	
	import mx.core.UIComponent;

	public class DishBallDetailPanel extends UIComponent
	{
		private var _dishDetailPanel:SimpleDishInfoPanel;
		
		private const BG_COLOR:uint = 0xC7C7C7;
		private const BG_ALPHA:Number = 0.8;
		
		public function DishBallDetailPanel()
		{
			super();
			
			InitPanel();
		}
		
		private function InitPanel():void
		{
			_dishDetailPanel = new SimpleDishInfoPanel;
			this.width = _dishDetailPanel.width;
			this.height = _dishDetailPanel.height + 10;
			this.addChild(_dishDetailPanel);
			_dishDetailPanel.x = 0;
			_dishDetailPanel.y = 0;
			
			DrawBG();
		}
		
		private function DrawBG():void
		{
			graphics.clear();
			graphics.beginFill(BG_COLOR, BG_ALPHA);
			graphics.drawRoundRect(0, 0, this.width, _dishDetailPanel.height, 5, 5);
			graphics.endFill();
		}
		
		public function updateDishInfo(name:String, level:int, count:int, xOffset:Number = -1):void
		{
			if (_dishDetailPanel != null)
			{
				_dishDetailPanel.dishName = name;
				_dishDetailPanel.dishLevel = level;
				_dishDetailPanel.dishCount = count;
			}
			
			updatePosition(xOffset);
		}
		
		public function updatePosition(xOffset:Number = -1):void
		{
			if (xOffset != -1)
			{
				DrawBG();
				graphics.beginFill(BG_COLOR, BG_ALPHA);
				graphics.moveTo(0, _dishDetailPanel.height);
				graphics.lineTo(xOffset, this.height);
				graphics.lineTo(this.width, _dishDetailPanel.height);
				graphics.lineTo(0, _dishDetailPanel.height);
				graphics.endFill();
			}
		}
		
	}
}