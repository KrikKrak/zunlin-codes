package com.Roxio.PhotoStar.Algorithm.PhotoAdjust
{
	import com.Roxio.PhotoStar.UI.EditPanel.ImageHolder;
	
	import flash.display.Graphics;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.containers.Canvas;
	
	public class CropAreaPanel extends Canvas
											implements IOverAdjustPanel
	{
		private static var _inst:CropAreaPanel = null;
		
		private const DRAG_POS_NO:uint = 0;
		private const DRAG_POS_UPPER_LEFT:uint = 1;
		private const DRAG_POS_UPPER_RIGHT:uint = 2;
		private const DRAG_POS_BOTTOM_LEFT:uint = 3;
		private const DRAG_POS_BOTTOM_RIGHT:uint = 4;
		private const DRAG_POS_TOP:uint = 5;
		private const DRAG_POS_BOTTOM:uint = 6;
		private const DRAG_POS_LEFT:uint = 7;
		private const DRAG_POS_RIGHT:uint = 8;
		private const DRAG_POS_ALL:uint = 9;
		
		private const DEFAULT_CROP_WIDTH:uint = 100;
		private const DEFAULT_CROP_HEIGHT:uint = 50;
		
		private var _cropPos:Array = new Array(4);
		private var _curMousePos:Array = new Array(2);
		private var _cropData:ImageHolder;
		
		private var _gHalfHandleSize:Number = 5;
		private var _gDragPosTolerance:Number = 2;
		private var _dragPos:uint = DRAG_POS_NO;
		private var _initWidth:Number;
		private var _initHeight:Number;
		
		public function CropAreaPanel()
		{
			super();
			
			SaveCropPos(10, 10, DEFAULT_CROP_WIDTH, DEFAULT_CROP_HEIGHT);
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, OnMouseDown, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_MOVE, OnMouseMove, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_UP, OnMouseUp, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_OUT, OnMouseOut, false, 0, true);
		}
	
		public static function inst():CropAreaPanel
		{
			if (_inst == null)
			{
				_inst = new CropAreaPanel;
			}
			return _inst;
		}
		
		public function setInitWH(w:Number, h:Number):void
		{
			_initWidth = w;
			_initHeight = h;
			
			this.x = 0;
			this.y = 0;
			this.width = w;
			this.height = h;
		}
		
		public function set cropData(data:ImageHolder):void
		{
			_cropData = data;
			
			// create a new crop area for frist time show up
			// make the area at the center of the SCREEN
			var rect:Rectangle = _cropData.dataGlobalRect;
			this.x = 0;
			this.y = 0;
			var lStartPos:Point = this.globalToLocal(new Point(rect.x, rect.y));
			
			var xCrop:Number = (_initWidth - DEFAULT_CROP_WIDTH) / 2;
			var yCrop:Number = (_initHeight - DEFAULT_CROP_HEIGHT) / 2;
			xCrop = (xCrop - lStartPos.x) / rect.width * _initWidth;
			yCrop = (yCrop - lStartPos.y) / rect.height * _initHeight;
			
			SaveCropPos(xCrop, yCrop, DEFAULT_CROP_WIDTH, DEFAULT_CROP_HEIGHT);
			updatePanelSize();
		}
		
		public function done():void
		{
			var alg:CropAlgorithm = new CropAlgorithm;
			alg.data = _cropData;
			alg.param = new Array(_cropData.bitmapData.width *_cropPos[0] / this.width,
											_cropData.bitmapData.height * _cropPos[1] / this.height,
											_cropData.bitmapData.width * _cropPos[2] / this.width,
											_cropData.bitmapData.height * _cropPos[3] / this.height);
			alg.execute();
		}
		
		public function cancel():void
		{
			return;
		}
		
		public function updatePanelSize():void
		{
			if (_cropData != null)
			{
				var rect:Rectangle = _cropData.dataGlobalRect;
				this.x = 0;
				this.y = 0;
				var lStartPos:Point = this.globalToLocal(new Point(rect.x, rect.y));
				MaskPosition(lStartPos.x, lStartPos.y, rect.width, rect.height);
			}
		}
		
		private function MaskPosition(px:Number, py:Number, pw:Number, ph:Number):void
		{
			var oriCropPosPerX:Number = _cropPos[0] / this.width;
			var oriCropPosPerY:Number = _cropPos[1] / this.height;
			var oriCropPosPerW:Number = _cropPos[2] / this.width;
			var oriCropPosPerH:Number = _cropPos[3] / this.height;
			
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
				g.drawRect(px - _gHalfHandleSize, py - _gHalfHandleSize, 2 * _gHalfHandleSize, 2 * _gHalfHandleSize);
				g.drawRect(px + pw - _gHalfHandleSize, py - _gHalfHandleSize, 2 * _gHalfHandleSize, 2 * _gHalfHandleSize);
				g.drawRect(px - _gHalfHandleSize, py + ph - _gHalfHandleSize, 2 * _gHalfHandleSize, 2 * _gHalfHandleSize);
				g.drawRect(px + pw - _gHalfHandleSize, py + ph - _gHalfHandleSize, 2 * _gHalfHandleSize, 2 * _gHalfHandleSize);
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
			_cropPos[0] = px;
			_cropPos[1] = py;
			_cropPos[2] = pw;
			_cropPos[3] = ph;
		}
		
		private function InDragHandler():Boolean
		{
			var halfHandleSize:Number = _gHalfHandleSize + _gDragPosTolerance;
			if (this.mouseX > _cropPos[0] - halfHandleSize && this.mouseX < _cropPos[0] + halfHandleSize
							&& this.mouseY > _cropPos[1] - halfHandleSize && this.mouseY < _cropPos[1] + halfHandleSize)
			{
				_dragPos = DRAG_POS_UPPER_LEFT;
				return true;
			}
			else if (this.mouseX > _cropPos[0] + _cropPos[2] - halfHandleSize && this.mouseX < _cropPos[0] + _cropPos[2] + halfHandleSize
							&& this.mouseY > _cropPos[1] - halfHandleSize && this.mouseY < _cropPos[1] + halfHandleSize)
			{
				_dragPos = DRAG_POS_UPPER_RIGHT;
				return true;
			}
			else if (this.mouseX > _cropPos[0] - halfHandleSize && this.mouseX < _cropPos[0] + halfHandleSize
							&& this.mouseY > _cropPos[1] + _cropPos[3] - halfHandleSize && this.mouseY < _cropPos[1] + _cropPos[3] + halfHandleSize)
			{
				_dragPos = DRAG_POS_BOTTOM_LEFT;
				return true;
			}
			else if (this.mouseX > _cropPos[0] + _cropPos[2] - halfHandleSize && this.mouseX < _cropPos[0] + _cropPos[2] + halfHandleSize
							&& this.mouseY > _cropPos[1] + _cropPos[3] - halfHandleSize && this.mouseY < _cropPos[1] + _cropPos[3] + halfHandleSize)
			{
				_dragPos = DRAG_POS_BOTTOM_RIGHT;
				return true;
			}
			else if (this.mouseX > _cropPos[0] + halfHandleSize && this.mouseX < _cropPos[0] + _cropPos[2] + halfHandleSize
							&& this.mouseY > _cropPos[1] - halfHandleSize && this.mouseY < _cropPos[1] + halfHandleSize)
			{
				_dragPos = DRAG_POS_TOP;
				return true;
			}
			else if (this.mouseX > _cropPos[0] + halfHandleSize && this.mouseX < _cropPos[0] + _cropPos[2] + halfHandleSize
							&& this.mouseY > _cropPos[1] + _cropPos[3] - halfHandleSize && this.mouseY < _cropPos[1] + _cropPos[3] + halfHandleSize)
			{
				_dragPos = DRAG_POS_BOTTOM;
				return true;
			}
			else if (this.mouseX > _cropPos[0] - halfHandleSize && this.mouseX < _cropPos[0] + halfHandleSize
							&& this.mouseY > _cropPos[1] + halfHandleSize && this.mouseY < _cropPos[1] + _cropPos[3] - halfHandleSize)
			{
				_dragPos = DRAG_POS_LEFT;
				return true;
			}
			else if (this.mouseX > _cropPos[0] + _cropPos[2] - halfHandleSize && this.mouseX < _cropPos[0] + _cropPos[2] + halfHandleSize
							&& this.mouseY > _cropPos[1] + halfHandleSize && this.mouseY < _cropPos[1] + _cropPos[3] - halfHandleSize)
			{
				_dragPos = DRAG_POS_RIGHT;
				return true;
			}
			else if (IsMouseInCropArea(this.mouseX, this.mouseY) == true)
			{
				_dragPos = DRAG_POS_ALL;
				return true;
			}
			else
			{
				_dragPos = DRAG_POS_NO;
				return false;
			}
		}
		
		private function OnMouseDown(event:MouseEvent):void
		{
			UpdateMousePos();
			InDragHandler();
		}
		
		private function OnMouseMove(event:MouseEvent):void
		{
			if (event.buttonDown == false)
			{
				return;
			}

			switch (_dragPos)
			{
				case DRAG_POS_NO:
					break;
				
				case DRAG_POS_UPPER_LEFT:
					DrawCorpArea(this.mouseX, this.mouseY, _cropPos[0] + _cropPos[2] - this.mouseX, _cropPos[1] + _cropPos[3] - this.mouseY);
					break;
					
				case DRAG_POS_UPPER_RIGHT:
					DrawCorpArea(_cropPos[0], this.mouseY, this.mouseX - _cropPos[0], _cropPos[1] + _cropPos[3] - this.mouseY);
					break;
					
				case DRAG_POS_BOTTOM_LEFT:
					DrawCorpArea(this.mouseX, _cropPos[1], _cropPos[0] + _cropPos[2] - this.mouseX, this.mouseY - _cropPos[1]);
					break;
					
				case DRAG_POS_BOTTOM_RIGHT:
					DrawCorpArea(_cropPos[0], _cropPos[1], this.mouseX - _cropPos[0], this.mouseY - _cropPos[1]);
					break;
					
				case DRAG_POS_TOP:
					DrawCorpArea(_cropPos[0], this.mouseY, _cropPos[2], _cropPos[1] + _cropPos[3] - this.mouseY);
					break;
					
				case DRAG_POS_BOTTOM:
					DrawCorpArea(_cropPos[0], _cropPos[1], _cropPos[2], this.mouseY - _cropPos[1]);
					break;
					
				case DRAG_POS_RIGHT:
					DrawCorpArea(_cropPos[0], _cropPos[1], this.mouseX - _cropPos[0], _cropPos[3]);
					break;
					
				case DRAG_POS_LEFT:
					DrawCorpArea(this.mouseX, _cropPos[1], _cropPos[0] + _cropPos[2] - this.mouseX, _cropPos[3]);
					break;
					
				case DRAG_POS_ALL:
					DrawCorpArea(_cropPos[0] + this.mouseX - _curMousePos[0], _cropPos[1] + this.mouseY - _curMousePos[1], _cropPos[2], _cropPos[3]);
					
				default:
					break;
			}
			UpdateMousePos();
		}
		
		private function OnMouseUp(event:MouseEvent):void
		{
			_dragPos = DRAG_POS_NO;
			SaveCropPos(_cropPos[0], _cropPos[1], _cropPos[2], _cropPos[3] ,true)
		}
		
		private function OnMouseOut(event:MouseEvent):void
		{
			OnMouseUp(event);
		}
		
		private function UpdateMousePos():void
		{
			_curMousePos[0] = this.mouseX;
			_curMousePos[1] = this.mouseY;
		}
		
		private function IsMouseInCropArea(px:Number, py:Number):Boolean
		{
			if (px > _cropPos[0] + _gHalfHandleSize + _gDragPosTolerance
									&& px < _cropPos[0] + _cropPos[2] - _gHalfHandleSize - _gDragPosTolerance
									&& py > _cropPos[1] + _gHalfHandleSize + _gDragPosTolerance
									&& py < _cropPos[1] + _cropPos[3] - _gHalfHandleSize - _gDragPosTolerance)
			{
				return true;
			}
			return false;
		}
		
	}
}