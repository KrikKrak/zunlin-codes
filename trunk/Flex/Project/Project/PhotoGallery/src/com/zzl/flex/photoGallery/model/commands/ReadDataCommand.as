package com.zzl.flex.photoGallery.model.commands
{
	public class ReadDataCommand
	{
		public static const C_READ_DATA:String = "Command_ReadData";
		
		public var dataSource:String;
		
		public function ReadDataCommand(ds:String)
		{
			dataSource = ds;
		}

	}
}