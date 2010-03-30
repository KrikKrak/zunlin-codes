package ASCode.PhotoAdjust
{
	import ASCode.PEBaseAction;
	
	import flash.display.Bitmap;

	public class SimpleAdjustAlgorithm extends PEBaseAction
	{
		protected var _filterArray:Array;
		
		override public function set data(val:Object):void
		{
			_data = val;
			_filterArray = (_data as Bitmap).filters.slice();
		}
		
		override public function Undo():Boolean
		{
			trace("Action: ", _actionName, ", Undo");
			(_data as Bitmap).filters = _filterArray;
			return true;
		}
	}
}