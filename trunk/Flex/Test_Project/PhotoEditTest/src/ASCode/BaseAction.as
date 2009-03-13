package ASCode
{
	public class BaseAction
	{
		protected var _actionName:String;
		
		public function Execute():Boolean
		{
			return true;
		}
		
		public function Undo():Boolean
		{
			return true;
		}
		
		public function Redo():Boolean
		{
			return true;
		}
		
		public function get actionName():String
		{
			return _actionName;
		}
	}
}