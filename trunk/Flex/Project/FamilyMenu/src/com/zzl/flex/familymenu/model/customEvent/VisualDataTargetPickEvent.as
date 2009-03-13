package com.zzl.flex.familymenu.model.customEvent
{
	import flash.events.Event;

	public class VisualDataTargetPickEvent extends Event
	{
		public static const E_VISUAL_DATA_TARGET_PICK:String = "VisualDataTargetPickEvent";

		public function VisualDataTargetPickEvent(type:String)
		{
			super(type, false, false);
		}
		
	}
}