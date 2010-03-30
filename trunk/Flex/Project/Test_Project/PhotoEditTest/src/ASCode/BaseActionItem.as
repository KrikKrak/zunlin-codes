package ASCode
{
	public class BaseActionItem
	{
		public var baseAction:BaseAction;
		public var actionName:String;
		
		public function BaseActionItem(action:BaseAction, name:String):void
		{
			baseAction = action;
			actionName = name;
		}
	}
}