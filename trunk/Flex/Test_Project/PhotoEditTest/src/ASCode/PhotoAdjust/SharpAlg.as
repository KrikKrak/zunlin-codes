package ASCode.PhotoAdjust
{
	import flash.utils.getTimer;
	import flash.filters.ConvolutionFilter;
	
	public class SharpAlg extends SimpleAdjustAlgorithm
	{
		public function SharpAlg():void
		{
			_actionName = "Sharp Adjust Action, ID: " + getTimer().toString();
			trace("New action created: ", _actionName);
		}
		
		public function Test(value:int):void
		{
			param = value;
			trace("Action: ", _actionName, ", Test");
			ActionBody(param);
		}
		
		override protected function ActionBody(param:Object):Boolean
		{
			trace("Action: ", _actionName, ", ActionBody");
			AdjustSharp(param as int);
			
			return true;
		}
		
		private function AdjustSharp(value:int):void
		{
			var MAX_SHARP_VALUE:int = 15;
			var cArray:Array = new Array(0, -1, 0,
													-1, 5, -1,
													0, -1, 0);
			cArray[4] = MAX_SHARP_VALUE - value;
			var convolution:ConvolutionFilter = new ConvolutionFilter;
			convolution.matrixX = 3;
			convolution.matrixY = 3;
			convolution.matrix = cArray;
			convolution.divisor = cArray[4] - 4;
			
			var tempFilter:Array = _filterArray.slice();
			tempFilter.push(convolution);
			_data.filters = tempFilter;
		}
	}
}