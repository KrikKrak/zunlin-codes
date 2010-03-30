package com.larryzzl.iBlog.event
{
	public class ArticleEvent extends MateEvent
	{
		public static const UPDATE_ARTICLE_CONTENT:String = "UPDATE_ARTICLE_CONTENT";
		
		public var articleId:String;
		public var articleTitle:String;
		public var articleBody:String;
		
		public function ArticleEvent(type:String)
		{
			super(type);
		}
		
	}
}