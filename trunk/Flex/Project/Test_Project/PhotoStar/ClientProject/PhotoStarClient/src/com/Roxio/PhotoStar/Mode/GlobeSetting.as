package com.Roxio.PhotoStar.Mode
{
	public class GlobeSetting
	{
		import mx.core.Application;
		
		public static const MODE_NEW:int = 0;
		public static const MODE_EDIT:int = 1;
		
		private static var _loadAnimRunning:Boolean = false;
		
		[Bindable]
		public static var isDataLoad:Boolean = false;
		
		public static var nextTargetLoadMethod:String = TargetLoadMethod.NOTHING;
		public static var nextTargetURL:String = "";
		public static var loadNextTarget:Boolean = false;
		
		public static function set loadAnimRunning(val:Boolean):void
		{
			_loadAnimRunning = val;
			Application.application.mainPage.maskApp(_loadAnimRunning);
		}
		
		public static function get loadAnimRunning():Boolean
		{
			return _loadAnimRunning;
		}
		
		[Bindable]
		public static var appMode:int = MODE_NEW;
		
		[Bindable]
		public static var currentTargetUrl:String = "";
		
		[Bindable]
		public static var done4Close:Boolean = true;
		
		private static var demoUrlArray:Array = new Array(4);
		private static var curDemoNo:int = -1;
		public static function get demoPhotoUrl():String
		{
			/* demoUrlArray[0] = "http://img132.photo.163.com/larryzzl/14177557/332276840.jpg";
			demoUrlArray[1] = "http://img227.photo.163.com/larryzzl/27506088/702461114.jpg";
			demoUrlArray[2] = "http://img227.photo.163.com/larryzzl/27506088/702462007.jpg";
			demoUrlArray[3] = "http://img227.photo.163.com/larryzzl/27506088/702464417.jpg";
			demoUrlArray[4] = "http://img227.photo.163.com/larryzzl/27506088/702462574.jpg";
			demoUrlArray[5] = "http://img189.photo.163.com/larryzzl/20996306/518457554.jpg";
			demoUrlArray[6] = "http://img170.photo.163.com/larryzzl/18500565/451451831.jpg";
			demoUrlArray[7] = "http://img132.photo.163.com/larryzzl/13958264/332281786.jpg";
			demoUrlArray[8] = "http://img132.photo.163.com/larryzzl/14177229/332262747.jpg";
			demoUrlArray[9] = "http://img132.photo.163.com/larryzzl/13957467/326188295.jpg"; */
			
			demoUrlArray[0] = "TestImage//z1.jpg";
			demoUrlArray[1] = "TestImage//z2.jpg";
			demoUrlArray[2] = "TestImage//z3.jpg";
			demoUrlArray[3] = "TestImage//z4.jpg";
			
			++curDemoNo;
			if (curDemoNo >= 4)
			{
				curDemoNo = 0;
			}
			return demoUrlArray[curDemoNo];
		}

	}
}