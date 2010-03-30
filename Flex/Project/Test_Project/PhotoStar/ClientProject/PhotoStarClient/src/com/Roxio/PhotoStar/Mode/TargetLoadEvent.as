package com.Roxio.PhotoStar.Mode
{
	import flash.events.Event;

	public class TargetLoadEvent extends Event
	{
		public static var IMAGE_START_LOAD:String = "IMAGE_START_LOAD";
		public static var IMAGE_LOADING:String = "IMAGE_LOADING";
		public static var IMAGE_LOADED:String = "IMAGE_LOADED";
		public static var IMAGE_LOAD_ERROR:String = "IMAGE_LOAD_ERROR";
		
		// IMAGE_LOADING properties
		public var loadPercent:Number = 0;
		
		// IMAGE_LOAD_ERROR properties
		public var errorID:int = 10000;
		public var errorText:String = "Unknown";

		public function TargetLoadEvent(type:String)
		{
			super(type, false, false);
		}
		
	}
}