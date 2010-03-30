package com.zzl.flex.photoGallery.model
{
	import flash.display.BitmapData;
	
	public class BasicPhotoInfo
	{
		public var fileName:String;
		public var sourceURL:String;
		public var data:BitmapData;
		public var initWidth:int;
		public var initHeight:int;
		public var loadStatus:String;
		public var loadPercent:int;
		public var loader:Object;
		
		public function cleanUp():void
		{
			data.dispose();
			data = null;
		}
	}
}