package com.zzl.flex.photoGallery.model.commands
{
	public class LoadSourceManageWndCommand
	{
		public static const C_LOAD_SOURCE_MANAGE_WND:String = "Command_LoadSourceManageWnd";
		
		public var load:Boolean;
		public var self:Object;
		
		public function LoadSourceManageWndCommand(l:Boolean, s:Object = null)
		{
			load = l;
			self = s;
		}

	}
}