package PEUIComponent.TransformToolSource.RoxioTVCursor
{
	import PEUIComponent.TransformToolSource.TransformToolCursor;
	import flash.events.Event;
	import mx.managers.CursorManager;
	
	public class RoxioTVTransformCursor extends TransformToolCursor
	{
		protected var curCursor:Class;
		private var cursorShow:Boolean = false;
		
		override public function updateVisible(event:Event = null):void
		{
			super.updateVisible(event);
			updateCursor();
		}
		
		override public function position(event:Event = null):void
		{
			if (parent) {
				x = parent.mouseX;
				y = parent.mouseY;
			}
		}
		
		private function updateCursor():void
		{
			if (visible == true)
			{
				if (cursorShow == false)
				{
					CursorManager.setCursor(curCursor);
					cursorShow = true;
				}
			}
			else
			{
				if (cursorShow == true)
				{
					CursorManager.removeAllCursors();
					cursorShow = false;
				}
			}
		}
		
		override protected function controlMove(event:Event):void
		{
			super.controlMove(event);
			updateCursor();
		}
	}
}