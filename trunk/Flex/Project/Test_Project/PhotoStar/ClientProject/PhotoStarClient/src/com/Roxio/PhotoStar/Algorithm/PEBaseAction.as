package com.Roxio.PhotoStar.Algorithm
{
	import com.Roxio.OnlineObject.DebugTool.TraceTool;
	
	public class PEBaseAction extends BaseAction
	{
		override public function undo():Boolean
		{
			TraceTool.Trace("Action: " + _actionName + ", Undo");
			// The derived class should rewrite the functino to execute the UNDO function
			return true;
		}
		
		override public function redo():Boolean
		{
			TraceTool.Trace("Action: " + _actionName + ", Redo");
			ActionBody(_param);
			return true;
		}
		
		override public function execute():Boolean
		{
			if (_param == null)
			{
				return false;
			}
			
			OnExecuteBegin();
			if (ActionBody(_param) == true)
			{
				TraceTool.Trace("Action: " + _actionName + ", Execute");
				ActionManager.addAction(this);
				return OnExecuteEnd();
			}
			else
			{
				return false;
			}
		}
		
		protected function OnExecuteBegin():void
		{
			return;
		}
		
		protected function ActionBody(param:Object):Boolean
		{
			return true;
		}
		
		protected function OnExecuteEnd():Boolean
		{
			return true;
		}
		
		////////////////////////////////////////////////////////////////////////////
		// From here, there are some Color Tool Function used in Photo edit.

		protected function GetAValue(color:uint):uint
		{
			return (color >> 24 & 0xFF);
		}
		
		protected function GetRValue(color:uint):uint
		{
			return (color >> 16 & 0xFF);
		}
		
		protected function GetGValue(color:uint):uint
		{
			return (color >> 8 & 0xFF);
		}
		
		protected function GetBValue(color:uint):uint
		{
			return (color & 0xFF);
		}
		
		protected function MergeARGB(a:uint, r:uint, g:uint, b:uint):uint
		{
			return ((a << 24) + (r << 16) + (g << 8) + b);
		}
		
		protected function MergeRGB(r:uint, g:uint, b:uint):uint
		{
			return ((0xFF << 24) + (r << 16) + (g << 8) + b);
		}
	}
}