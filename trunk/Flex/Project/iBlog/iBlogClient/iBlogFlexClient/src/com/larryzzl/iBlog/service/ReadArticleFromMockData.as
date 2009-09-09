package com.larryzzl.iBlog.service
{
	import com.larryzzl.iBlog.model.MainModelLocator;
	import com.larryzzl.iBlog.model.modelDef.BlogArticle;
	import com.larryzzl.iBlog.util.GUIDGenerator;
	
	public class ReadArticleFromMockData extends ArticleReader
	{
		public function ReadArticleFromMockData()
		{
			super();
			
		}
		
		override public function readArticle():void
		{
			for (var i:int = 0; i < MainModelLocator.MAX_NUMBER_OF_ITEM_READ_ONCE; ++i)
			{
				var ba:BlogArticle = new BlogArticle;
				ba.articleId = GUIDGenerator.getGUID();
				ba.articleAuthor = _model.currentUser;
				ba.articleTitle = "Demo article title " + i;
				ba.articleBody = "Test article body " + i;
				ba.articleCreatedDate = new Date;
				ba.articleCreatedDate.fullYear = 2009;
				ba.articleCreatedDate.month = Math.random() * 11 + 1;
				ba.articleLastEditDate = ba.articleCreatedDate;
				
				_articles.push(ba);
			}
			
			ArticleReaded();
		}
		
		override protected function ArticleReaded():void
		{
			_model.localBlogArticles = _articles;
		}
		
	}
}