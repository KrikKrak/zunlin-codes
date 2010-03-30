package com.larryzzl.iBlog.event
{
	import flash.events.Event;

	public class MateEvent extends Event
	{
		public function MateEvent(type:String)
		{
			super(type, true, false);
		}
		
	}
}