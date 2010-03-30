package PEUIComponent
{
	import ASCode.PhotoAdjust.CropAlgorithm;
	import ASCode.PhotoEditBitmap;
	
	import flash.display.Graphics;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class CropAreaPanel extends DragPanel
	{
		private static var inst:CropAreaPanel = null;
		private var cropPos:Array = new Array(4);
		private var cropData:PhotoEditBitmap;
		
		private var cropAreaMoveable:Boolean = false;
		private var gHalfHandleSize:Number = 5;
		private var gDragPosTolerance:Number = 2;
		private const DRAG_POS_NO:uint = 0;
		private const DRAG_POS_UPPER_LEFT:uint = 1;
		private const DRAG_POS_UPPER_RIGHT:uint = 2;
		private const DRAG_POS_BOTTOM_LEFT:uint = 3;
		private const DRAG_POS_BOTTOM_RIGHT:uint = 4;
		private const DRAG_POS_TOP:uint = 5;
		private const DRAG_POS_BOTTOM:uint = 6;
		private const DRAG_POS_LEFT:uint = 7;
		private const DRAG_POS_RIGHT:uint = 8;
		private var dragPos:uint = DRAG_POS_NO;
		
		private var initWidth:Number;
		private var initHeight:Number;
		private const DEFAULT_CROP_WIDTH:uint = 100;
		private const DEFAULT_CROP_HEIGHT:uint = 50;
		
		public function CropAreaPanel()
		{
			super();
			
			SaveCropPos(10, 10, DEFAULT_CROP_WIDTH, DEFAULT_CROP_HEIGHT);
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, OnMouseDown, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_MOVE, OnMouseMove, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_UP, OnMouseUp, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_OUT, OnMouseOut, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_OVER, OnMouseOver, false, 0, true);
		}
	
		public static function GetCropPanel():CropAreaPanel
		{
			if (inst == null)
			{
				inst = new CropAreaPanel;
			}
			return inst;
		}
		
		public function SetInitWH(w:Number, h:Number):void
		{
			initWidth = w;
			initHeight = h;
			
			this.x = 0;
			this.y = 0;
			this.width = w;
			this.height = h;
		}
		
		public function SetCropBitmap(data:PhotoEditBitmap):void
		{
			cropData = data;
			
			// create a new crop area for frist time show up
			// make the area at the center of the SCREEN
			var rect:Rectangle = cropData.dataGlobalRect;
			this.x = 0;
			this.y = 0;
			var lStartPos:Point = this.globalToLocal(new Point(rect.x, rect.y));
			
			var xCrop:Number = (initWidth - DEFAULT_CROP_WIDTH) / 2;
			var yCrop:Number = (initHeight - DEFAULT_CROP_HEIGHT) / 2;
			xCrop = (xCrop - lStartPos.x) / rect.width * initWidth;
			yCrop = (yCrop - lStartPos.y) / rect.height * initHeight;
			
			SaveCropPos(xCrop, yCrop, DEFAULT_CROP_WIDTH, DEFAULT_CROP_HEIGHT);
			DataSizeChange();
		}
		
		public function CropDone():void
		{
			var alg:CropAlgorithm = new CropAlgorithm;
			alg.data = cropData;
			alg.param = new Array(cropData.bitmapData.width *cropPos[0] / this.width,
											cropData.bitmapData.height * cropPos[1] / this.height,
											cropData.bitmapData.width * cropPos[2] / this.width,
											cropData.bitmapData.height * cropPos[3] / this.height);
			alg.Execute();
		}
		
		override public function IsMouseOver(mx:Number, my:Number):Boolean
		{
			var local:Point = this.globalToLocal(new Point(mx,my));
			if (IsMouseInCropArea(local.x, local.y) == true)
			{
				cropAreaMoveable = true
			}
			else
			{
				cropAreaMoveable = false;
			}
			return true;
		}
		
		override public function get moveable():Boolean
		{
			return cropAreaMoveable;
		}
		
		override public function CanDrag(mx:Number, my:Number):Boolean
		{
			return (InDragHandler() == DRAG_POS_NO);
		}
		
		override public function ChangDragPos(xOffset:Number, yOffset:Number):void
		{
			DrawCorpArea(cropPos[0] + xOffset, cropPos[1] + yOffset, cropPos[2], cropPos[3]);
		}
		
		public function DataSizeChange():void
		{
			if (cropData != null)
			{
				var rect:Rectangle = cropData.dataGlobalRect;
				this.x = 0;
				this.y = 0;
				var lStartPos:Point = this.globalToLocal(new Point(rect.x, rect.y));
				MaskPosition(lStartPos.x, lStartPos.y, rect.width, rect.height);
			}
		}
		
		private function MaskPosition(px:Number, py:Number, pw:Number, ph:Number):void
		{
			var oriCropPosPerX:Number = cropPos[0] / this.width;
			var oriCropPosPerY:Number = cropPos[1] / this.height;
			var oriCropPosPerW:Number = cropPos[2] / this.width;
			var oriCropPosPerH:Number = cropPos[3] / this.height;
			
			this.x = px;
			this.y = py;
			this.width = pw;
			this.height = ph;
			
			DrawCorpArea(this.width * oriCropPosPerX, this.height * oriCropPosPerY,
												this.width * oriCropPosPerW, this.height * oriCropPosPerH);
		}
		
		private function DrawCorpArea(px:Number, py:Number, pw:Number, ph:Number):void
		{
			if (px < 0 || py < 0 || px + pw > this.width || py + ph > this.height)
			{
				return;
			}
			
			SaveCropPos(px, py, pw, ph);
			
			var g:Graphics = graphics;
		    g.clear();
		    
		    var maskColor:uint = 0x000000;
		    var frameColor:uint =  0xFF8000;
            var frameThickness:Number = 1;
            
			g.lineStyle(frameThickness, frameColor, 0);
			g.beginFill(maskColor, 0.3);
				g.drawRect(0, 0, px, this.height);
				g.drawRect(px, 0, this.width - px, py);
				g.drawRect(px + pw, py, this.width - px - pw, this.height - py);
				g.drawRect(px, py + ph, pw, this.height - py - ph);
			g.endFill();
			
			g.beginFill(frameColor, 0.7);
				g.drawRect(px - gHalfHandleSize, py - gHalfHandleSize, 2 * gHalfHandleSize, 2 * gHalfHandleSize);
				g.drawRect(px + pw - gHalfHandleSize, py - gHalfHandleSize, 2 * gHalfHandleSize, 2 * gHalfHandleSize);
				g.drawRect(px - gHalfHandleSize, py + ph - gHalfHandleSize, 2 * gHalfHandleSize, 2 * gHalfHandleSize);
				g.drawRect(px + pw - gHalfHandleSize, py + ph - gHalfHandleSize, 2 * gHalfHandleSize, 2 * gHalfHandleSize);
			g.endFill();
			
			g.lineStyle(frameThickness, frameColor, 1);
			g.drawRect(px, py, pw, ph);
			g.moveTo(px, py + ph / 3);
			g.lineTo(px + pw, py + ph / 3);
			g.moveTo(px, py + ph * 2 / 3);
			g.lineTo(px + pw, py + ph * 2 / 3);
			g.moveTo(px + pw / 3, py);
			g.lineTo(px + pw / 3, py + ph);
			g.moveTo(px + pw - pw / 3, py);
			g.lineTo(px + pw - pw / 3, py + ph);
		}
		
		private function SaveCropPos(px:Number, py:Number, pw:Number, ph:Number, reorg:Boolean = false):void
		{
			if (reorg == true)
			{
				if (pw < 0)
				{
					px += pw;
					pw = -pw;
				}
				if (ph < 0)
				{
					py += ph;
					ph = -ph;
				}
			}
			cropPos[0] = px;
			cropPos[1] = py;
			cropPos[2] = pw;
			cropPos[3] = ph;
		}
		
		private function InDragHandler():Boolean
		{
			var halfHandleSize:Number = gHalfHandleSize + gDragPosTolerance;
			if (this.mouseX > cropPos[0] - halfHandleSize && this.mouseX < cropPos[0] + halfHandleSize
							&& this.mouseY > cropPos[1] - halfHandleSize && this.mouseY < cropPos[1] + halfHandleSize)
			{
				dragPos = DRAG_POS_UPPER_LEFT;
				return true;
			}
			else if (this.mouseX > cropPos[0] + cropPos[2] - halfHandleSize && this.mouseX < cropPos[0] + cropPos[2] + halfHandleSize
							&& this.mouseY > cropPos[1] - halfHandleSize && this.mouseY < cropPos[1] + halfHandleSize)
			{
				dragPos = DRAG_POS_UPPER_RIGHT;
				return true;
			}
			else if (this.mouseX > cropPos[0] - halfHandleSize && this.mouseX < cropPos[0] + halfHandleSize
							&& this.mouseY > cropPos[1] + cropPos[3] - halfHandleSize && this.mouseY < cropPos[1] + cropPos[3] + halfHandleSize)
			{
				dragPos = DRAG_POS_BOTTOM_LEFT;
				return true;
			}
			else if (this.mouseX > cropPos[0] + cropPos[2] - halfHandleSize && this.mouseX < cropPos[0] + cropPos[2] + halfHandleSize
							&& this.mouseY > cropPos[1] + cropPos[3] - halfHandleSize && this.mouseY < cropPos[1] + cropPos[3] + halfHandleSize)
			{
				dragPos = DRAG_POS_BOTTOM_RIGHT;
				return true;
			}
			else if (this.mouseX > cropPos[0] + halfHandleSize && this.mouseX < cropPos[0] + cropPos[2] + halfHandleSize
							&& this.mouseY > cropPos[1] - halfHandleSize && this.mouseY < cropPos[1] + halfHandleSize)
			{
				dragPos = DRAG_POS_TOP;
				return true;
			}
			else if (this.mouseX > cropPos[0] + halfHandleSize && this.mouseX < cropPos[0] + cropPos[2] + halfHandleSize
							&& this.mouseY > cropPos[1] + cropPos[3] - halfHandleSize && this.mouseY < cropPos[1] + cropPos[3] + halfHandleSize)
			{
				dragPos = DRAG_POS_BOTTOM;
				return true;
			}
			else if (this.mouseX > cropPos[0] - halfHandleSize && this.mouseX < cropPos[0] + halfHandleSize
							&& this.mouseY > cropPos[1] + halfHandleSize && this.mouseY < cropPos[1] + cropPos[3] - halfHandleSize)
			{
				dragPos = DRAG_POS_LEFT;
				return true;
			}
			else if (this.mouseX > cropPos[0] + cropPos[2] - halfHandleSize && this.mouseX < cropPos[0] + cropPos[2] + halfHandleSize
							&& this.mouseY > cropPos[1] + halfHandleSize && this.mouseY < cropPos[1] + cropPos[3] - halfHandleSize)
			{
				dragPos = DRAG_POS_RIGHT;
				return true;
			}
			else
			{
				dragPos = DRAG_POS_NO;
				return false;
			}
		}
		
		private function OnMouseDown(event:MouseEvent):void
		{
			InDragHandler();
		}
		
		private function OnMouseMove(event:MouseEvent):void
		{
			if (event.buttonDown == false)
			{
				return;
			}
			/*
			if (Math.min(cropPos[0], cropPos[0] + cropPos[2]) <= 0
				|| Math.min(cropPos[1], cropPos[1] + cropPos[2]) <= 0
				|| Math.max(cropPos[0], cropPos[0] + cropPos[2]) >= this.width
				|| Math.max(cropPos[1], cropPos[1] + cropPos[3]) >= this.height)
			{
				return;
			}
			*/
			if (this.mouseX < 0 || this.mouseX > this.width || this.mouseY < 0 || this.mouseY > this.height)
			{
				return;
			}
			
			switch (dragPos)
			{
				case DRAG_POS_NO:
					return;
				
				case DRAG_POS_UPPER_LEFT:
					DrawCorpArea(this.mouseX, this.mouseY, cropPos[0] + cropPos[2] - this.mouseX, cropPos[1] + cropPos[3] - this.mouseY);
					break;
					
				case DRAG_POS_UPPER_RIGHT:
					DrawCorpArea(cropPos[0], this.mouseY, this.mouseX - cropPos[0], cropPos[1] + cropPos[3] - this.mouseY);
					break;
					
				case DRAG_POS_BOTTOM_LEFT:
					DrawCorpArea(this.mouseX, cropPos[1], cropPos[0] + cropPos[2] - this.mouseX, this.mouseY - cropPos[1]);
					break;
					
				case DRAG_POS_BOTTOM_RIGHT:
					DrawCorpArea(cropPos[0], cropPos[1], this.mouseX - cropPos[0], this.mouseY - cropPos[1]);
					break;
					
				case DRAG_POS_TOP:
					DrawCorpArea(cropPos[0], this.mouseY, cropPos[2], cropPos[1] + cropPos[3] - this.mouseY);
					break;
					
				case DRAG_POS_BOTTOM:
					DrawCorpArea(cropPos[0], cropPos[1], cropPos[2], this.mouseY - cropPos[1]);
					break;
					
				case DRAG_POS_RIGHT:
					DrawCorpArea(cropPos[0], cropPos[1], this.mouseX - cropPos[0], cropPos[3]);
					break;
					
				case DRAG_POS_LEFT:
					DrawCorpArea(this.mouseX, cropPos[1], cropPos[0] + cropPos[2] - this.mouseX, cropPos[3]);
					break;
					
				default:
					return;
			}
		}
		
		private function OnMouseUp(event:MouseEvent):void
		{
			dragPos = DRAG_POS_NO;
			cropAreaMoveable = false;
			SaveCropPos(cropPos[0], cropPos[1], cropPos[2], cropPos[3] ,true)
		}
		
		private function OnMouseOut(event:MouseEvent):void
		{
			cropAreaMoveable = false;
		}
		
		private function OnMouseOver(event:MouseEvent):void
		{
			cropAreaMoveable = true;
		}
		
		private function IsMouseInCropArea(px:Number, py:Number):Boolean
		{
			if (px > cropPos[0] - gHalfHandleSize - gDragPosTolerance
									&& px < cropPos[0] + cropPos[2] + gHalfHandleSize + gDragPosTolerance
									&& py > cropPos[1] - gHalfHandleSize - gDragPosTolerance
									&& py < cropPos[1] + cropPos[3] + gHalfHandleSize + gDragPosTolerance)
			{
				return true;
			}
			return false;
		}
		
	}
}