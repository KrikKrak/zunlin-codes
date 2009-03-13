package com.zzl.flex.familymenu.model.viewCommand
{
	import com.zzl.flex.familymenu.model.DishDetail;
	
	public class NewDishSubmitCommand extends CommonCommand
	{
		public static const NAME:String = "NewDishSubmitCommand";
		public var dishDetail:DishDetail = new DishDetail;
	}
}