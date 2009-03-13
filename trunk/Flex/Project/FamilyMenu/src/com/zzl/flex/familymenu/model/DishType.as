package com.zzl.flex.familymenu.model
{
	import mx.collections.ArrayCollection;
	
	public class DishType
	{
		public static const PURE_MEAT:String = "大荤";
		public static const HALF_MEAT:String = "小荤";
		public static const FOWL:String = "禽类";
		public static const FISH:String = "水产品";
		public static const MEAT:String = "肉类";
		public static const SEA_FOOD:String = "海鲜";
		public static const VEGETABLE:String = "蔬菜";
		public static const OTHER:String = "其他";
		
		public static function get typeMap():ArrayCollection
		{
			var a:ArrayCollection = new ArrayCollection;
			a.addItem(PURE_MEAT);
			a.addItem(HALF_MEAT);
			a.addItem(FOWL);
			a.addItem(FISH);
			a.addItem(MEAT);
			a.addItem(SEA_FOOD);
			a.addItem(VEGETABLE);
			a.addItem(OTHER);
			return a;
		}
	}
}