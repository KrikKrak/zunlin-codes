package com.zzl.flex.familymenu.model.customEvent
{
	import flash.events.Event;

	public class VisualDataTargetMouseEvent extends Event
	{
		public static const E_VISUAL_DATA_TARGET_MOUSE_OUT:String = "VisualDataTargetMouseOutEvent";
		public static const E_VISUAL_DATA_TARGET_MOUSE_OVER:String = "VisualDataTargetMouseOverEvent";

		public function VisualDataTargetMouseEvent(type:String)
		{
			super(type, false, false);
		}
		
	}
}