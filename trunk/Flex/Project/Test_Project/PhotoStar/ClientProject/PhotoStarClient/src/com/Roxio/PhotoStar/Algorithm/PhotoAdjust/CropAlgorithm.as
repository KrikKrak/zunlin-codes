package com.Roxio.PhotoStar.Algorithm.PhotoAdjust
{
	import com.Roxio.OnlineObject.DebugTool.TraceTool;
	import com.Roxio.PhotoStar.Algorithm.PEBaseAction;
	import com.Roxio.PhotoStar.Mode.ActionName;
	import com.Roxio.PhotoStar.UI.EditPanel.ImageHolder;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class CropAlgorithm extends PEBaseAction
	{
		private var _bitmapData:BitmapData;
		
		public function CropAlgorithm()
		{
			_actionName = ActionName.CROP;
			TraceTool.Trace("New action created: " + _actionName);
		}
		
		override public function toActionXML():XML
		{
			var paramArray:Array = param as Array;
			var nodeXML:XML = <Crop>
											<StartX>{paramArray[0] as Number}</StartX>
											<StartY>{paramArray[1] as Number}</StartY>
											<Width>{paramArray[2] as Number}</Width>
											<Height>{paramArray[3] as Number}</Height>
										</Crop>;
			return nodeXML;
		}
		
		override public function set data(val:Object):void
		{
			_data = val;
			_bitmapData = (_data as ImageHolder).bitmapData.clone();
		}
		
		override public function undo():Boolean
		{
			TraceTool.Trace("Action: " + _actionName + ", Undo");
			(_data as ImageHolder).changeBitmapData(_bitmapData);
			return true;
		}
		
		override protected function ActionBody(param:Object):Boolean
		{
			var paramArray:Array = param as Array;
			TraceTool.Trace("Action: " + _actionName + ", ActionBody");
			CropBitmap(paramArray[0], paramArray[1], paramArray[2], paramArray[3]);
			
			return true;
		}
		
		private function CropBitmap(px:Number, py:Number, pw:Number, ph:Number):void
		{
			var newData:BitmapData = new BitmapData(pw, ph);
			newData.copyPixels(_bitmapData, new Rectangle(px, py, pw, ph), new Point(0, 0));
			(_data as ImageHolder).changeBitmapData(newData);
			newData.dispose();
		}
	}
}