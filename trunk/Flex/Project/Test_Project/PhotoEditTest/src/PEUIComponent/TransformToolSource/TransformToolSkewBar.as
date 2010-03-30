package PEUIComponent.TransformToolSource
{
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	public class TransformToolSkewBar extends TransformToolInternalControl
	{
		private var locationStart:String;
		private var locationEnd:String;
		
		function TransformToolSkewBar(name:String, interactionMethod:Function, referenceName:String, locationStart:String, locationEnd:String) {
			super(name, interactionMethod, referenceName);
			this.locationStart = locationStart;
			this.locationEnd = locationEnd;
		}
		
		override public function draw(event:Event = null):void {
			graphics.clear();
			
			if (_skin) {
				super.draw(event);
				return;
			}
			
			// derive point locations for bar
			var locStart:Point = _transformTool[locationStart];
			var locEnd:Point = _transformTool[locationEnd];
			
			// counter transform
			var toolTrans:Matrix;
			var toolTransInverted:Matrix;
			var maintainControlForm:Boolean = _transformTool.maintainControlForm;
			if (maintainControlForm) {
				toolTrans = transform.concatenatedMatrix;
				toolTransInverted = toolTrans.clone();
				toolTransInverted.invert();
				
				locStart = toolTrans.transformPoint(locStart);
				locEnd = toolTrans.transformPoint(locEnd);
			}
			
			var size:Number = _transformTool.controlSize/2;
			var diff:Point = locEnd.subtract(locStart);
			var angle:Number = Math.atan2(diff.y, diff.x) - Math.PI/2;	
			var offset:Point = Point.polar(size, angle);
			
			var corner1:Point = locStart.add(offset);
			var corner2:Point = locEnd.add(offset);
			var corner3:Point = locEnd.subtract(offset);
			var corner4:Point = locStart.subtract(offset);
			if (maintainControlForm) {
				corner1 = toolTransInverted.transformPoint(corner1);
				corner2 = toolTransInverted.transformPoint(corner2);
				corner3 = toolTransInverted.transformPoint(corner3);
				corner4 = toolTransInverted.transformPoint(corner4);
			}
			
			// draw bar
			graphics.beginFill(0xFF0000, 0);
			graphics.moveTo(corner1.x, corner1.y);
			graphics.lineTo(corner2.x, corner2.y);
			graphics.lineTo(corner3.x, corner3.y);
			graphics.lineTo(corner4.x, corner4.y);
			graphics.lineTo(corner1.x, corner1.y);
			graphics.endFill();
		}
	
		override public function position(event:Event = null):void {
			if (_skin) {
				var locStart:Point = _transformTool[locationStart];
				var locEnd:Point = _transformTool[locationEnd];
				var location:Point = Point.interpolate(locStart, locEnd, .5);
				x = location.x;
				y = location.y;
			}else{
				x = 0;
				y = 0;
				draw(event);
			}
		}
	}
}