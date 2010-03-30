package com.zzl.flex.LogUrFeeling.Model.FeelingCommands
{
	public class SubmitFeelingCommand extends BaseCommand
	{
		public var feeling:int;
		public var name:String;
		public var email:String;
		public var note:String;
		
		public static const C_SUBMIT_FEELING:String = "SubmitFeelingCommand";
		
		public function SubmitFeelingCommand(cName:String, f:int, n:String = null, e:String = null, no:String = null)
		{
			feeling = f;
			if (n != null) name = n;
			if (e != null) email = e;
			if (no != null) note = no;
			
			super(cName);
		}
	}
}