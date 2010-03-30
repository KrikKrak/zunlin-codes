package ASCode
{
	public class ActionManager
	{
		private static var _actions:Array = new Array;
		private static var _curActionIndex:int = -1;
		
		private static var _canUndo:Boolean = false;
		private static var _canRedo:Boolean = false;
		
		private static var _oriState:Object = null;
		
		public static function AddAction(action:BaseAction):int
		{
			// if user call undo first, remove all the actions behind cur action first.
			if (_actions.length != _curActionIndex + 1)
			{
				_actions.splice(_curActionIndex + 1, _actions.length - _curActionIndex - 1);
			}
			else if (_curActionIndex == -1 && _actions.length > 0)
			{
				_actions.splice(0, _actions.length);
			}
			_actions.push(new BaseActionItem(action, action.actionName));
			++_curActionIndex;
			UpdateStatic();
			trace("ActionManager, AddAction called, cur index: ", _curActionIndex, "Action name:", action.actionName);
			return _curActionIndex;
		}
		
		public static function Undo():BaseAction
		{
			if (_canUndo == false)
			{
				return null;
			}
			
			var action:BaseAction = (_actions[_curActionIndex] as BaseActionItem).baseAction;
			if (action.Undo() == true)
			{
				--_curActionIndex;
				UpdateStatic();
				trace("ActionManager, Undo called, cur index: ", _curActionIndex, "Undo class: ", action.actionName);
				return action;
			}
			else
			{
				return null;
			}
		}
		
		public static function Redo():BaseAction
		{
			if (_canRedo == false)
			{
				return null;
			}
			
			var action:BaseAction = (_actions[_curActionIndex + 1] as BaseActionItem).baseAction;
			if (action.Redo() == true)
			{
				++_curActionIndex;
				UpdateStatic();
				trace("ActionManager, Undo called, cur index: ", _curActionIndex, "Undo class: ", action.actionName);
				return action;
			}
			else
			{
				return null;
			}
		}
		
		public static function get curActionIndex():int
		{
			return _curActionIndex;
		}
		
		public static function get actions():Array
		{
			return _actions;
		}
		
		public static function get canUndo():Boolean
		{
			return _canUndo;
		}
		
		public static function get canRedo():Boolean
		{
			return _canRedo;
		}
		
		private static function UpdateStatic():void
		{
			_canUndo = (_curActionIndex > -1);
			_canRedo = ((_curActionIndex < _actions.length - 1 && _curActionIndex > -1)
								|| (_curActionIndex == -1 && _actions.length > 0));
		}
			
	}
}