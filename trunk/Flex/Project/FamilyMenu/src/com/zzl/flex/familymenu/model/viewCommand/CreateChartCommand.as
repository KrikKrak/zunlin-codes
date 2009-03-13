package com.zzl.flex.familymenu.model.viewCommand
{
	import mx.collections.ArrayCollection;
	import mx.core.UIComponent;
	
	public class CreateChartCommand extends CommonCommand
	{
		public static const NAME:String = "CreateChartCommand";
		public var chartParent:UIComponent;
		public var chartData:ArrayCollection;
		public var chartType:String;
	}
}