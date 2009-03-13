package com.Roxio.PhotoStar.Algorithm.PhotoAdjust
{
	import com.Roxio.OnlineObject.DebugTool.TraceTool;
	import com.Roxio.PhotoStar.Mode.ActionName;
	
	import com.Roxio.PhotoStar.Algorithm.PEBaseAction;
	import com.Roxio.PhotoStar.UI.EditPanel.ImageHolder;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;

	public class FlipAlgorithm extends PEBaseAction
	{
		public static var MIRROR_HORIZONTAL:uint = 0;
		public static var MIRROR_VERTICAL:uint = 1;
		
		public function FlipAlgorithm()
		{
			_actionName = ActionName.FLIP;
			TraceTool.Trace("New action created: " + _actionName);
		}
		
		override public function toActionXML():XML
		{
			var nodeXML:XML = <Flip>
											<Direction>{param as uint}</Direction>
										</Flip>;
			return nodeXML;
		}
		
		override public function undo():Boolean
		{
			TraceTool.Trace("Action: " + _actionName + ", Undo");
			Flip(param as uint);
			return true;
		}
		
		override protected function ActionBody(param:Object):Boolean
		{
			TraceTool.Trace("Action: " + _actionName + ", ActionBody");
			Flip(param as uint);
			return true;
		}
		
		private function Flip(dir:uint):void
		{
			var bitmap:Bitmap = (_data as ImageHolder).bitmap;
			bitmap.x = 0;
			bitmap.y = 0;
			bitmap.width = bitmap.bitmapData.width;
			bitmap.height = bitmap.bitmapData.height;
			
			// get the transform matrix and do the flip
			var oriMatrix:Matrix = bitmap.transform.matrix.clone();
			var matrix:Matrix = bitmap.transform.matrix;
			if (dir == MIRROR_VERTICAL)
			{
				matrix.scale(1, -1);
				matrix.translate(0, bitmap.height);
			}
			else
			{
				matrix.scale(-1, 1);
				matrix.translate(bitmap.width, 0);
			}
			bitmap.transform.matrix = matrix;
			// hold the older filters and ready to copy the bitmapdata
			var oriFilters:Array = bitmap.filters;
			bitmap.filters = null;
			// copy the rotated bitmapdata to new data
			var newData:BitmapData = new BitmapData(bitmap.width, bitmap.height);
			newData.draw(bitmap, matrix, null, null, null, true);
			// resume the 
			bitmap.transform.matrix = oriMatrix.clone();
			bitmap.filters = oriFilters;
			(_data as ImageHolder).changeBitmapData(newData);
		}
	}
}