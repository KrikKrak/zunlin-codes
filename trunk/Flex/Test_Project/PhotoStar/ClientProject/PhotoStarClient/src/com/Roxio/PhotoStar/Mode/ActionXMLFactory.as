package com.Roxio.PhotoStar.Mode
{
	import com.Roxio.PhotoStar.Algorithm.ActionManager;
	import com.Roxio.PhotoStar.Algorithm.BaseActionItem;
	
	public class ActionXMLFactory
	{
		public function ActionXMLFactory()
		{
			super();
		}
		
		public static function toXML():XML
		{
			if (ActionManager.actions.length == 0 || ActionManager.curActionIndex < 0)
			{
				return null;
			}
			
			var actionXML:XML = <Actions></Actions>;
			for (var i:int = 0; i <= ActionManager.curActionIndex; ++i)
			{
				actionXML.appendChild((ActionManager.actions[i] as BaseActionItem).baseAction.toActionXML().copy());
			}
			return actionXML;
		}
	}
}