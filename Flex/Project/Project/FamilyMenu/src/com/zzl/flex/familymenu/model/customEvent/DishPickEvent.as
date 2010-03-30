package com.zzl.flex.familymenu.model.customEvent
{
	import com.zzl.flex.familymenu.model.DishDetail;
	
	import flash.events.Event;

	public class DishPickEvent extends Event
	{
		public static const E_DISH_PICK:String = "DishPickEvent";
		
		public var result:DishDetail
		
		public function DishPickEvent(type:String)
		{
			super(type, false, false);
		}
		
	}
}