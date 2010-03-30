package ASCode.PhotoAdjust
{
	import flash.utils.getTimer;
	import flash.filters.ColorMatrixFilter;
	
	public class ExpContAdjAlg extends SimpleAdjustAlgorithm
	{
		public function ExpContAdjAlg():void
		{
			_actionName = "Exposure Adjust Action, ID: " + getTimer().toString();
			trace("New action created: ", _actionName);
		}
		
		public function Test(bright:Number, contrast:Number):void
		{
			param = new Array(bright, contrast);
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
		
		private function AdjustExpCont(exp:Number, cont:Number):void
		{
			var cm:ColorMatrixCreator = new ColorMatrixCreator;
			cm.adjustBrightness(exp);
			cm.adjustContrast(cont);
			var cmf:ColorMatrixFilter = new ColorMatrixFilter;
			cmf.matrix = cm.colorMatrix;
			
			var tempFilter:Array = _filterArray.slice();
			tempFilter.push(cmf);
			_data.filters = tempFilter;
		}
	}
}