package com.zzl.flex.familymenu.model.customEvent
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;

	public class ComplexSearchResultEvent extends Event
	{
		public static const E_COMPLEX_SEARCH_RESULT:String = "ComplexSearchResultEvent";
		
		public var result:ArrayCollection;
		
		public function ComplexSearchResultEvent(type:String)
		{
			super(type, false, false);
		}
		
	}
}