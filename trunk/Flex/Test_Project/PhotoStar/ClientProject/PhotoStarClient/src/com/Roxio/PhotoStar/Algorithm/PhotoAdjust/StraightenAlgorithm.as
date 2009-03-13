package com.Roxio.PhotoStar.Algorithm.PhotoAdjust
{
	import com.Roxio.OnlineObject.DebugTool.TraceTool;
	import com.Roxio.PhotoStar.Mode.ActionName;
	
	import com.Roxio.PhotoStar.Algorithm.PEBaseAction;
	import com.Roxio.PhotoStar.UI.EditPanel.ImageHolder;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;

	public class StraightenAlgorithm extends PEBaseAction
	{
		private var _radianAngle:Number = 0;
		private var _oriTransMatrix:Matrix;
		private var _oriWidth:Number;
		private var _oriHeight:Number;
		private var _oriBitmapData:BitmapData;
		
		public function StraightenAlgorithm()
		{
			_actionName = ActionName.STRAIGHTEN;
			TraceTool.Trace("New action created: " + _actionName);
		}
		
		override public function set data(val:Object):void
		{
			_data = val;
			_oriTransMatrix = (_data as ImageHolder).bitmap.transform.matrix.clone();
			_oriWidth = (_data as ImageHolder).bitmapData.width;
			_oriHeight = (_data as ImageHolder).bitmapData.height;
			_oriBitmapData = (_data as ImageHolder).bitmapData.clone();
		}
		
		public function test(radianAngle:Number):void
		{
			TraceTool.Trace("Action: " + _actionName + ", Test");
			
			_radianAngle += radianAngle;
			param = _radianAngle;
			
			// restore the bitmap data first
			(_data as ImageHolder).changeBitmapData(_oriBitmapData.clone());
			ActionBody(param);
		}
		
		public function cancel():void
		{
			(_data as ImageHolder).changeBitmapData(_oriBitmapData.clone());
		}
		
		override public function toActionXML():XML
		{
			var nodeXML:XML = <Straighten>
											<RadianAngle>{param as Number}</RadianAngle>
										</Straighten>;
			return nodeXML;
		}
		
		override public function undo():Boolean
		{
			TraceTool.Trace("Action: " + _actionName + ", Undo");
			UnRotate(param as Number);
			return true;
		}
		
		override protected function ActionBody(param:Object):Boolean
		{
			TraceTool.Trace("Action: " + _actionName + ", ActionBody");
			Rotate(param as Number);
			return true;
		}
		
		override protected function OnExecuteEnd():Boolean
		{
			// destory the saved bitmapdata to release the memory
			_oriBitmapData.dispose();
			return true;
		}
		
		override protected function OnExecuteBegin():void
		{
			(_data as ImageHolder).changeBitmapData(_oriBitmapData.clone());
		}
		
		private function Rotate(ra:Number):void
		{
			// the angle should be in radian and -90 <= angle <= 90
			var bitmap:Bitmap = (_data as ImageHolder).bitmap;
			bitmap.x = 0;
			bitmap.y = 0;
			bitmap.width = bitmap.bitmapData.width;
			bitmap.height = bitmap.bitmapData.height;
			
			// get the transform matrix and do the rotate
			var matrix:Matrix = bitmap.transform.matrix;
			matrix.rotate(ra);
			// move the pic to the center of the bitmap
			if (ra < 0)
			{
				matrix.ty = _oriWidth * Math.sin(-ra);
			}
			else
			{
				matrix.tx = _oriHeight * Math.sin(ra);
			}
			bitmap.transform.matrix = matrix;
			// hold the older filters and ready to copy the bitmapdata
			var oriFilters:Array = bitmap.filters;
			bitmap.filters = null;
			// copy the rotated bitmapdata to new data
			var newData:BitmapData = new BitmapData(bitmap.width, bitmap.height);
			newData.draw(bitmap, matrix, null, null, null, true);
			// resume the 
			bitmap.transform.matrix = _oriTransMatrix.clone();
			bitmap.filters = oriFilters;
			(_data as ImageHolder).changeBitmapData(newData);
		}
		
		private function UnRotate(ra:Number):void
		{
			// This function assurme that a rotate action has been done
			// so there is some special pos of the bitmapdata in bitmap
			// We rotate it back and put it to the center
			var bitmap:Bitmap = (_data as ImageHolder).bitmap;
			bitmap.width = bitmap.bitmapData.width;
			bitmap.height = bitmap.bitmapData.height;
			bitmap.x = 0;
			bitmap.y = 0;
			 
			var actAngle:Number = -ra;
			var matrix:Matrix = bitmap.transform.matrix;
			matrix.rotate(actAngle);
			if (actAngle < 0)
			{
				matrix.tx = -_oriHeight * Math.sin(-actAngle) * Math.cos(-actAngle);
				matrix.ty = _oriHeight * Math.sin(-actAngle) * Math.sin(-actAngle);
			}
			else
			{
				matrix.tx = _oriWidth * Math.sin(actAngle) * Math.sin(actAngle);
				matrix.ty = -_oriWidth * Math.sin(actAngle) * Math.cos(actAngle);
			}
			bitmap.transform.matrix = matrix;
			
			var oriFilters:Array = bitmap.filters;
			bitmap.filters = null;
			
			var newData:BitmapData = new BitmapData(_oriWidth, _oriHeight);
			newData.draw(bitmap, matrix, null, null, null, true);
			
			bitmap.transform.matrix = _oriTransMatrix.clone();
			bitmap.filters = oriFilters;
			(_data as ImageHolder).changeBitmapData(newData);
		}
	}
}