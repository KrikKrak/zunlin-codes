package com.Roxio.PhotoStar.Algorithm.PhotoAdjust
{
	import com.Roxio.OnlineObject.DebugTool.TraceTool;
	import com.Roxio.PhotoStar.Mode.ActionName;
	
	import flash.filters.ColorMatrixFilter;
	
	public class StandardAdjustAlg extends SimpleAdjustAlgorithm
	{
		public function StandardAdjustAlg():void
		{
			_actionName = ActionName.STANDARD;
			TraceTool.Trace("New action created: " + _actionName);
		}
		
		public function test(bright:Number, contrast:Number, sat:Number, hue:Number):void
		{
			param = new Array(bright, contrast, sat, hue);
			TraceTool.Trace("Action: " + _actionName + ", Test");
			ActionBody(param);
		}
		
		override public function toActionXML():XML
		{
			var paramArray:Array = param as Array;
			var nodeXML:XML = <StandardAjdust>
											<Brightness>{paramArray[0] as Number}</Brightness>
											<Contrast>{paramArray[1] as Number}</Contrast>
											<Saturation>{paramArray[2] as Number}</Saturation>
											<Hue>{paramArray[3] as Number}</Hue>
										</StandardAjdust>;
			return nodeXML;
		}
		
		override protected function ActionBody(param:Object):Boolean
		{
			var paramArray:Array = param as Array;
			TraceTool.Trace("Action: " + _actionName + ", ActionBody");
			AdjustExpCont(paramArray[0], paramArray[1], paramArray[2], paramArray[3]);
			
			return true;
		}
		
		private function AdjustExpCont(bright:Number, cont:Number, sat:Number, hue:Number):void
		{
			var cm:ColorMatrixCreator = new ColorMatrixCreator;
			cm.adjustBrightness(bright);
			cm.adjustContrast(cont);
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