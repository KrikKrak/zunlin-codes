package com.larryzzl.iBlog.model.modelDef
{
	public class BlogArticle extends SyncableModel
	{
		public function BlogArticle()
		{
			super();
		}
		
		public var articleId:String;
		public var articleTitle:String;
		public var articleBody:String;
		public var articleAuthor:UserInfo;
		public var articleCreatedDate:Date;
		public var articleLastEditDate:Date;
		
	}
}