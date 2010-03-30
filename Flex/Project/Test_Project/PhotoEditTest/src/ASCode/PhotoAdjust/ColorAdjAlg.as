package ASCode.PhotoAdjust
{
	import flash.utils.getTimer;
	import flash.filters.ColorMatrixFilter;
	
	public class ColorAdjAlg extends SimpleAdjustAlgorithm
	{
		public function ColorAdjAlg():void
		{
			_actionName = "Color Adjust Action, ID: " + getTimer().toString();
			trace("New action created: ", _actionName);
		}
		
		public function Test(sat:Number, hue:Number):void
		{
			param = new Array(sat, hue);
			trace("Action: ", _actionName, ", Test");
			ActionBody(param);
		}
		
		override protected function ActionBody(param:Object):Boolean
		{
			var paramArray:Array = param as Array;
			trace("Action: ", _actionName, ", ActionBody");
			AdjustExpCont(paramArray[0], paramArray[1]);
			
			return true;
		}
		
		private function AdjustExpCont(sat:Number, hue:Number):void
		{
			var cm:ColorMatrixCreator = new ColorMatrixCreator;
			cm.adjustSaturation(sat);
			cm.adjustHue(hue);
			var cmf:ColorMatrixFilter = new ColorMatrixFilter;
			cmf.matrix = cm.colorMatrix;
			
			var tempFilter:Array = _filterArray.slice();
			tempFilter.push(cmf);
			_data.filters = tempFilter;
		}
	}
}