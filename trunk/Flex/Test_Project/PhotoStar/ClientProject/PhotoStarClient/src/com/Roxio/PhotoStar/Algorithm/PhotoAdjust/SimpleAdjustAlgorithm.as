package com.Roxio.PhotoStar.Algorithm.PhotoAdjust
{
	import com.Roxio.OnlineObject.DebugTool.TraceTool;
	
	import com.Roxio.PhotoStar.Algorithm.PEBaseAction;
	
	import flash.display.Bitmap;

	public class SimpleAdjustAlgorithm extends PEBaseAction
	{
		protected var _filterArray:Array;
		
		override public function set data(val:Object):void
		{
			_data = val;
			_filterArray = (_data as Bitmap).filters.slice();
		}
		
		override public function undo():Boolean
		{
			TraceTool.Trace("Action: " + _actionName + ", Undo");
			(_data as Bitmap).filters = _filterArray;
			return true;
		}
	}
}