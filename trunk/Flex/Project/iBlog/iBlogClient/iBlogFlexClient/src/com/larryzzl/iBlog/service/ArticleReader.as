package com.larryzzl.iBlog.service
{
	import com.larryzzl.iBlog.model.MainModelLocator;
	import com.larryzzl.iBlog.model.modelDef.BlogArticle;
	
	/**
	 * This is a base class for reading articles service.
	 * All sub-classes should override the readArticle() and articleReaded() functions.
	 * 
	 * @author Larry
	 * 
	 */	
	public class ArticleReader
	{
		protected var _model:MainModelLocator = MainModelLocator.inst;
		protected var _articles:Vector.<BlogArticle>;
		
		public function ArticleReader()
		{
			_articles = new Vector.<BlogArticle>;
		}
		
		public function readArticle():void
		{
			trace("readArticle() gets called in base class");
		}
		
		protected function ArticleReaded():void
		{
			trace("articleReaded() gets called in base class");
		}

	}
}