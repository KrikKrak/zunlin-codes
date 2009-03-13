package com.Roxio.PhotoStar.Mode
{
	import flash.events.Event;

	public class TargetProcessEvent extends Event
	{
		public static var TARGET_CHANGE:String = "TARGET_CHANGE";
		
		public function TargetProcessEvent(type:String)
		{
			super(type, false, false);
		}
		
	}
}