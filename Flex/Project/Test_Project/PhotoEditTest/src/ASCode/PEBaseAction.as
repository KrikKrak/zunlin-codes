package ASCode
{
	public class PEBaseAction extends BaseAction
	{
		protected var _data:Object;
		protected var _param:Object;
		
		public function set data(val:Object):void
		{
			_data = val;
		}
		
		public function set param(val:Object):void
		{
			_param = val;
		}
		
		public function get param():Object
		{
			return _param;
		}
		
		override public function Undo():Boolean
		{
			trace("Action: ", _actionName, ", Undo");
			// The derived class should rewrite the functino to execute the UNDO function
			return true;
		}
		
		override public function Redo():Boolean
		{
			trace("Action: ", _actionName, ", Redo");
			ActionBody(_param);
			return true;
		}
		
		override public function Execute():Boolean
		{
			if (_param == null)
			{
				return false;
			}
			
			OnExecuteBegin();
			if (ActionBody(_param) == true)
			{
				trace("Action: ", _actionName, ", Execute");
				ActionManager.AddAction(this);
				return OnExecuteEnd();
			}
			else
			{
				return false;
			}
		}
		
		protected function ActionBody(param:Object):Boolean
		{
			return true;
		}
		
		protected function OnExecuteEnd():Boolean
		{
			return true;
		}
		
		protected function OnExecuteBegin():void
		{
			return;
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