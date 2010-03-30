package com.Roxio.PhotoStar.Algorithm
{
	import com.Roxio.OnlineObject.DebugTool.TraceTool;
	import com.Roxio.PhotoStar.Mode.GlobeSetting;
	import com.Roxio.PhotoStar.Server.DataController;
	
	public class ActionManager
	{
		private static var _actions:Array = new Array;
		private static var _curActionIndex:int = -1;
		
		[Bindable]
		public static var canUndo:Boolean = false;
		[Bindable]
		public static var canRedo:Boolean = false;
		
		public static function addAction(action:BaseAction):int
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
			UpdateStatus();
			TraceTool.Trace("ActionManager, AddAction called, cur index: " + _curActionIndex, "Action name:" + action.actionName);
			return _curActionIndex;
		}
		
		public static function undo():BaseAction
		{
			if (canUndo == false)
			{
				return null;
			}
			
			var action:BaseAction = (_actions[_curActionIndex] as BaseActionItem).baseAction;
			if (action.undo() == true)
			{
				TraceTool.Trace("ActionManager, Undo called, cur index: " + _curActionIndex, "Undo name:" + action.actionName);
				--_curActionIndex;
				UpdateStatus();
				return action;
			}
			else
			{
				return null;
			}
		}
		
		public static function redo():BaseAction
		{
			if (canRedo == false)
			{
				return null;
			}
			
			var action:BaseAction = (_actions[_curActionIndex + 1] as BaseActionItem).baseAction;
			if (action.redo() == true)
			{
				++_curActionIndex;
				UpdateStatus();
				TraceTool.Trace("ActionManager, Redo called, cur index: " + _curActionIndex, "Redo name:" + action.actionName);
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
		
		private static function UpdateStatus():void
		{
			canUndo = (_curActionIndex > -1);
			canRedo = ((_curActionIndex < _actions.length - 1 && _curActionIndex > -1)
								|| (_curActionIndex == -1 && _actions.length > 0));
			
			DataController.controller.dataChanged = canUndo;
		}
			
	}
}