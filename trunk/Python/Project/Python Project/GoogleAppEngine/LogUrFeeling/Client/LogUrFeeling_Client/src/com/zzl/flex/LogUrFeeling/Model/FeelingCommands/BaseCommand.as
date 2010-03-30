package com.zzl.flex.LogUrFeeling.Model.FeelingCommands
{
	public class BaseCommand
	{
		protected var _commandName:String;
		
		public function BaseCommand(cName:String)
		{
			_commandName = cName;
		}
		
		public function get commandName():String
		{
			return _commandName;
		}

	}
}