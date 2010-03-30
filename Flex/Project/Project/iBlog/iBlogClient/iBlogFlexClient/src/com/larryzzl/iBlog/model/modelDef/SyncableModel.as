package com.larryzzl.iBlog.model.modelDef
{
	public class SyncableModel
	{
		public static const UP_TO_DATE:String = "UP_TO_DATE";
		public static const DIRTY:String = "DIRTY";
		public static const NEW:String = "NEW";
		
		public var modelState:String = NEW;
		
		public function SyncableModel()
		{
		}

	}
}