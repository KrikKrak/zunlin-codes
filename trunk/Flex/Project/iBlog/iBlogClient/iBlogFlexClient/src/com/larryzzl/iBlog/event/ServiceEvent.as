package com.larryzzl.iBlog.event
{
	public class ServiceEvent extends MateEvent
	{
		public static const READ_LATEST_ARTICLES:String = "READ_LATEST_ARTICLES";
		
		public function ServiceEvent(type:String)
		{
			super(type);
		}
		
	}
}