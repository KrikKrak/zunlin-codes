package ASCode.PhotoAdjust
{
	import ASCode.PEBaseAction;
	import ASCode.PhotoEditBitmap;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;

	public class CropAlgorithm extends PEBaseAction
	{
		private var _bitmapData:BitmapData;
		
		public function CropAlgorithm()
		{
			_actionName = "Crop Action, ID: " + getTimer().toString();
			trace("New action created: ", _actionName);
		}
		
		override public function set data(val:Object):void
		{
			_data = val;
			_bitmapData = (_data as PhotoEditBitmap).bitmapData.clone();
		}
		
		override public function Undo():Boolean
		{
			trace("Action: ", _actionName, ", Undo");
			(_data as PhotoEditBitmap).ChangeBitmapData(_bitmapData);
			return true;
		}
		
		override protected function ActionBody(param:Object):Boolean
		{
			var paramArray:Array = param as Array;
			trace("Action: ", _actionName, ", ActionBody");
			CropBitmap(paramArray[0], paramArray[1], paramArray[2], paramArray[3]);
			
			return true;
		}
		
		private function CropBitmap(px:Number, py:Number, pw:Number, ph:Number):void
		{
			var newData:BitmapData = new BitmapData(pw, ph);
			newData.copyPixels(_bitmapData, new Rectangle(px, py, pw, ph), new Point(0, 0));
			(_data as PhotoEditBitmap).ChangeBitmapData(newData);
			newData.dispose();
		}
	}
}