package com.zzl.flex.familymenu.model.customEvent
{
	import flash.events.Event;

	public class VisualDataTargetMouseEvent extends Event
	{
		public static const E_VISUAL_DATA_TARGET_MOUSE_OUT:String = "VisualDataTargetMouseOutEvent";
		public static const E_VISUAL_DATA_TARGET_MOUSE_OVER:String = "VisualDataTargetMouseOverEvent";
		public static const E_VISUAL_DATA_TARGET_MOUSE_MOVE:String = "VisualDataTargetMouseMoveEvent";
		public static const E_VISUAL_DATA_TARGET_MOUSE_CLICK:String = "VisualDataTargetMouseClickEvent";
		
		public static const E_VISUAL_DATA_TARGET_MOUSE_START_DRAG:String = "VisualDataTargetMouseStartDragEvent";
		public static const E_VISUAL_DATA_TARGET_MOUSE_END_DRAG:String = "VisualDataTargetMouseEndDragEvent";

		public function VisualDataTargetMouseEvent(type:String)
		{
			super(type, false, false);
		}
		
	}
}