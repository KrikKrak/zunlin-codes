package com.larryzzl.iBlog.event
{
	public class ServiceEvent extends MateEvent
	{
		public static const READ_LATEST_ARTICLES:String = "READ_LATEST_ARTICLES";
		public static const UPDATE_ATRICLE_TO_SERVER:String = "UPDATE_ATRICLE_TO_SERVER";
		
		public var articleId:String;
		public var articleTitle:String;
		public var articleBody:String;
		
		public function ServiceEvent(type:String)
		{
			super(type);
		}
		
	}
}