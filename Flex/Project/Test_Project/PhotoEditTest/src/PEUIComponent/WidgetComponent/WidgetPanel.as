package PEUIComponent.WidgetComponent
{
	import ASCode.PhotoEditBitmap;
	
	import PEUIComponent.IDragPanel;
	import PEUIComponent.TransformToolSource.TransformTool;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.containers.Canvas;
	import mx.core.UIComponent;

	public class WidgetPanel extends UIComponent
										implements IDragPanel
	{
		private static var inst:WidgetPanel;
		private var transformTool:TransformTool;
		private var maskShape:Shape;
		private var background:Canvas;
		private var mainPic:PhotoEditBitmap;
		
		private var widgetBucket:Array = new Array;
		private var gScale:Number = 1;
		
		public function WidgetPanel()
		{
			super();
			
			transformTool = new TransformTool;
			background = new Canvas;
			background.addEventListener(MouseEvent.MOUSE_DOWN, OnMouseDown);
		}
		
		public static function GetWidgetPanel():WidgetPanel
		{
			if (inst == null)
			{
				inst = new WidgetPanel;
			}
			return inst;
		}
		
		public function set data(val:PhotoEditBitmap):void
		{
			mainPic = val;
			mainPic.addEventListener("event_DataMove", OnMainPicMove, false, 0, true);
		}
		
		public function IsMouseOver(mx:Number, my:Number):Boolean
		{
			trace("IsMouseOver");
			return (transformTool.target != null);
		}
		
		public function get moveable():Boolean
		{
			return false;
		}
		
		public function CanDrag(mx:Number, my:Number):Boolean
		{
			return false;
		}
		
		public function ChangDragPos(xOffset:Number, yOffset:Number):void
		{
			return;
		}
		
		public function EndWidgetEdit():void
		{
			mainPic.removeEventListener("event_DataMove", OnMainPicMove);
			transformTool.target = null;
		}
		
		public function AddWidget(obj:DisplayObject):void
		{
			if (obj == null)
			{
				return;
			}
			
			this.addChild(obj);
			widgetBucket.push(obj);
			SetTransformTarget(obj);
			obj.addEventListener(MouseEvent.MOUSE_DOWN, OnWidgetDown, false, 0, true);
		}
		
		public function UpdatePanelSize(gRect:Rectangle):void
		{
			gScale = gRect.width / this.width;
			this.x = 0;
			this.y = 0;
			var lStartPos:Point = this.globalToLocal(new Point(gRect.x, gRect.y));
			this.x = lStartPos.x;
			this.y = lStartPos.y;
			trace("wb", this.width, "wa", gRect.width);
			var xOffset:Number = (this.width - gRect.width) / 2;
			var yOffset:Number = (this.height - gRect.height) / 2;
			trace("x", -xOffset, "y", -yOffset);
			this.width = gRect.width;
			this.height = gRect.height;
			background.x = 0;
			background.y = 0;
			background.width = this.width;
			background.height = this.height;
			CreateMask();
			UpdateToolSize(-xOffset, -yOffset);
		}
		
		override protected function createChildren():void
        {
            super.createChildren();
            addChild(background);
            addChild(transformTool);
            UpdateToolSize();
        }
        
        private function OnMainPicMove(event:Event):void
        {
        	UpdatePanelSize(mainPic.dataGlobalRect);
        }
        
        private function CreateMask():void
        {
        	if (maskShape == null)
        	{
        		maskShape = new Shape;
        	}
        	else
        	{
        		removeChild(maskShape);
        	}
        	maskShape.graphics.clear();
			maskShape.graphics.lineStyle(1, 0x000000);
			maskShape.graphics.beginFill(0xff0000);
			maskShape.graphics.drawRect(0, 0, this.width, this.height);
			maskShape.graphics.endFill();
			maskShape.alpha = 0.0;
			addChild(maskShape);
			this.mask = maskShape;
        }
        
        private function SetTransformTarget(obj:DisplayObject):void
        {
        	transformTool.target = null;
        	transformTool.target = obj;
			transformTool.raiseNewTargets = false;
			transformTool.moveUnderObjects = false;
			transformTool.skewEnabled = false;
			transformTool.constrainScale = true;
			transformTool.singleSideScaleEnable = false;
			transformTool.rememberRegistration = false;
			transformTool.registrationEnabled = false;
			transformTool.registration = transformTool.boundsCenter;
			
			this.setChildIndex(transformTool, this.numChildren - 1);
        }
        
        private function UpdateToolSize(xOffset:Number = 0, yOffset:Number = 0):void
        {
        	transformTool.x = 0;
        	transformTool.y = 0;
        	transformTool.width = this.width;
        	transformTool.height = this.height;
        	
        	for (var i:int = 0; i  < widgetBucket.length; ++i)
        	{
        		var widget:DisplayObject = widgetBucket[i] as DisplayObject;
        		if (widget != transformTool.target)
        		{
        			trace("not change", widget, transformTool.target, i);
        			ZoomWidget(widget);
        		}
        		else
        		{
        			var objSize:Rectangle = transformTool.objectSize;
        			trace("=== change size", gScale, objSize.width, gScale * objSize.width);
        			transformTool.newTargetSize(gScale * objSize.width, 0, xOffset, yOffset);
        		}
        	}
        }
        
        private function ZoomWidget(widget:DisplayObject):void
        {
        	if (widget == null)
        	{
        		return;
        	}
        	
        	var newWidth:Number = widget.width * gScale;
        	var newHeight:Number = widget.height * gScale;
        	widget.x += (widget.width - newWidth) / 2;
        	widget.y += (widget.height - newHeight) / 2;
        }
        
        private function OnWidgetDown(event:MouseEvent):void
        {
        	if (transformTool.target != (event.currentTarget as DisplayObject))
        	{
        		SetTransformTarget(event.target as DisplayObject);
        	}
        	trace("OnWidgetDown");
        }
		
		private function OnMouseDown(event:MouseEvent):void
		{
			trace(event.target, event.currentTarget);
			if (event.target == background)
			{
				transformTool.target = null;
			}
		}
	}
}