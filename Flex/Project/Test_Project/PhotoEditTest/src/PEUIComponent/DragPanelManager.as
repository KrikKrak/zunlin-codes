package PEUIComponent
{
	import mx.core.UIComponent;
	
	public class DragPanelManager
	{
		private static var _panelContainer:Array = new Array;
		
		public static function AddPanel(panel:IDragPanel):Boolean
		{
			if (FindInArray(panel) == -1)
			{
				_panelContainer.unshift(panel);
				return true;
			}
			return false;
		}
		
		public static function RemovePanel(panel:IDragPanel):Boolean
		{
			var pos:int = FindInArray(panel);
			if (pos != -1)
			{
				_panelContainer.splice(pos, 1);
				return true
			}
			return false;
		}
		
		public static function GetMouseOverPanel(mx:Number, my:Number):IDragPanel
		{
			for (var i:int = 0; i < _panelContainer.length; ++i)
			{
				var panel:IDragPanel = _panelContainer[i] as IDragPanel;
				if (panel.IsMouseOver(mx, my) == true)
				{
					if (panel.CanDrag(mx, my) == true)
					{
						return _panelContainer[i] as IDragPanel;
					}
					break;
				}
			}
			return null;
		}
		
		public static function GetPanel(pos:int):IDragPanel
		{
			if (pos >= 0 && pos < _panelContainer.length - 1)
			{
				return _panelContainer[pos] as IDragPanel;
			}
			return null;
		}
		
		public static function GetPanelIndex(panel:IDragPanel):int
		{
			return FindInArray(panel);
		}
		
		private static function FindInArray(target:IDragPanel):int
		{
			for (var i:int = 0; i < _panelContainer.length; ++i)
			{
				if (_panelContainer[i] == target)
				{
					return i;
				}
			}
			return -1;
		}
	}
}