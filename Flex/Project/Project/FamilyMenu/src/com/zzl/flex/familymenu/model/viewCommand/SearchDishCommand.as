package com.zzl.flex.familymenu.model.viewCommand
{
	import mx.collections.ArrayCollection;
	
	public class SearchDishCommand extends CommonCommand
	{
		public static const NAME:String = "SearchDishCommand";
		
		public var searchRang:ArrayCollection;
		public var keywords:ArrayCollection;
		public var category:ArrayCollection;
		public var type:ArrayCollection;
		public var hot:ArrayCollection;
		public var season:ArrayCollection;
		public var rate:ArrayCollection;
		
		public var resultCallbackFunction:Function;
	}
}