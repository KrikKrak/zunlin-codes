package com.zzl.flex.familymenu.model
{
	import mx.collections.ArrayCollection;
	
	public class DishCategory
	{
		public static const BUFFET:String = "冷盆";
		public static const HEAT:String = "热炒";
		public static const SOUP:String = "汤";
		public static const NOSH:String = "点心";
		public static const MAIN_FOOD:String = "主食";
		public static const BRISE_FOOD:String = "炖菜";
		public static const OTHER:String = "其他";
		
		public static function get categoryMap():ArrayCollection
		{
			var a:ArrayCollection = new ArrayCollection;
			a.addItem(BUFFET);
			a.addItem(HEAT);
			a.addItem(SOUP);
			a.addItem(NOSH);
			a.addItem(MAIN_FOOD);
			a.addItem(BRISE_FOOD);
			a.addItem(OTHER);
			return a;
		}

	}
}