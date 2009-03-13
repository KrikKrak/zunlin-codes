package com.Roxio.PhotoStar.UI.EditPanel
{
	import com.Roxio.PhotoStar.Mode.TargetProcessEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.UIComponent;

	public class ImageHolder extends UIComponent
	{
		private var _bitmap:Bitmap;
		private var _oriWidth:Number;
		private var _oriHeight:Number;
		private var _oriScale:Number;
		private var _curScale:Number = 1;
		
		private var _mouseDown:Boolean = false;
		private var _mousePos:Array;
		
		public function ImageHolder(bitmapData:BitmapData)
		{
			super();
			
			_bitmap = new Bitmap(bitmapData.clone());
			_bitmap.x = 0;
			_bitmap.y = 0;
			_bitmap.smoothing = true;
			_oriWidth = _bitmap.width;
			_oriHeight = _bitmap.height;
			_oriScale = _bitmap.scaleX;
			
			_mousePos = new Array(2);
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, OnMouseDown, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_MOVE, OnMouseMove, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_UP, OnMouseUp, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_OUT, OnMouseOut, false, 0, true);
		}
		
		override public function set width(value:Number):void
        {
            super.width = value;
            CalcBitmapSize();
        }

        override public function get width():Number
        {
            return super.width;
        }

        override public function set height(value:Number):void
        {
            super.height = value;
            CalcBitmapSize();
        }

        override public function get height():Number
        {
            return super.height;
        }
		
		public function get bitmap():Bitmap
		{
			return _bitmap;
		}
		
		public function get bitmapData():BitmapData
		{
			return _bitmap.bitmapData;
		}
		
		public function get bitmapRatioWH():Number
        {
        	return (_oriWidth / _oriHeight);
        }
		
		public function get bitmapScale():Number
        {
        	return _bitmap.scaleX;
        }
        
        public function set bitmapScale(nu:Number):void
        {
        	PutBitmapOriPos(nu);
        	_bitmap.scaleX = nu;
        	_bitmap.scaleY = nu;

        	FitBitmap2Border();
        }
		
		public function get dataGlobalRect():Rectangle
		{
			var gStartPos:Point = this.localToGlobal(new Point(_bitmap.x, _bitmap.y));
			return new Rectangle(gStartPos.x, gStartPos.y, _bitmap.width, _bitmap.height);
		}
		
		public function changeBitmapData(bitmapData:BitmapData):void
        {
        	if (this.contains(_bitmap))
        	{
        		this.removeChild(_bitmap);
        	}
        	
        	_bitmap.bitmapData.dispose();
        	_bitmap = new Bitmap(bitmapData.clone());
        	addChild(_bitmap);
			_bitmap.x = 0;
			_bitmap.y = 0;
			_bitmap.smoothing = true;
			_oriWidth = _bitmap.width;
			_oriHeight = _bitmap.height;
			_oriScale = _bitmap.scaleX;

			CalcBitmapSize();
			dispatchEvent(new TargetProcessEvent(TargetProcessEvent.TARGET_CHANGE));
        }

		public function newSize(width:Number, height:Number):void
		{
			super.width = width;
			super.height = height;
			CalcBitmapSize();
		}
		
		public function updateHolderSize(width:Number, height:Number):void
		{
			super.width = width;
			super.height = height;
			
			FitBitmap2Border();
		}
		
		override protected function createChildren():void
        {
            super.createChildren();
            if (this.contains(_bitmap) == false)
            {
            	addChild(_bitmap);
            }
        }

        private function RemoveUnusedChild():void
        {
        	while (this.numChildren > 1)
        	{
        		this.removeChildAt(this.numChildren - 1);
        	}
        }
        
        private function FitBitmap2Border():void
        {
        	if (_bitmap.x > 0 && _bitmap.width > this.width)
        	{
        		_bitmap.x = 0;
        	}
        	
        	if (_bitmap.x + _bitmap.width < this.width && _bitmap.width > this.width)
        	{
        		_bitmap.x = this.width - _bitmap.width;
        	}
        	
        	if (_bitmap.width <= this.width)
        	{
        		_bitmap.x = (this.width - _bitmap.width) / 2;
        	}
        	
        	if (_bitmap.y > 0 && _bitmap.height > this.height)
        	{
        		_bitmap.y = 0;
        	}
        	
        	if (_bitmap.y + _bitmap.height < this.height && _bitmap.height > this.height)
        	{
        		_bitmap.y = this.height - _bitmap.height;
        	}
        	
        	if (_bitmap.height <= this.height)
        	{
        		_bitmap.y = (this.height - _bitmap.height) / 2;
        	}
        }

        private function CalcBitmapSize():void
        {
        	var ratio:Number = this.bitmapRatioWH;
			if (ratio > this.width / this.height)
			{
				_bitmap.x = 0;
				_bitmap.y = (this.height - this.width / ratio) / 2;
				_bitmap.width = this.width;
            	_bitmap.height = _bitmap.width / ratio;
			}
			else
			{
				_bitmap.x = (this.width - this.height * ratio) / 2;;
				_bitmap.y = 0;
				_bitmap.height = this.height;
	            _bitmap.width = _bitmap.height * ratio;
			}

        	_oriScale = _bitmap.scaleX;
        }
        
        private function PutBitmapOriPos(newScale:Number):void
        {
        	var centerX:Number = this.width / 2;
        	var centerY:Number = this.height / 2;
        	_bitmap.x = centerX - ((centerX - _bitmap.x) * newScale / _bitmap.scaleX);
        	_bitmap.y = centerY - ((centerY - _bitmap.y) * newScale / _bitmap.scaleX);
        }
        
        private function MoveBitmap(xOffset:Number, yOffset:Number):void
		{
			if (_bitmap.x + xOffset < 0 && _bitmap.x + _bitmap.width + xOffset > this.width)
			{
				_bitmap.x += xOffset;
			}
			if (_bitmap.y + yOffset < 0 && _bitmap.y + _bitmap.height + yOffset > this.height)
			{
				_bitmap.y += yOffset;
			}
		}
		
		private function OnMouseDown(event:MouseEvent):void
		{
			_mouseDown = true;
			SaveMousePos();
		}
		
		private function OnMouseMove(event:MouseEvent):void
		{
			if (_mouseDown == true)
			{
				MoveBitmap(this.mouseX - _mousePos[0], this.mouseY - _mousePos[1]);
				SaveMousePos();
			}
		}
		
		private function OnMouseUp(event:MouseEvent):void
		{
			_mouseDown = false;
		}
		
		private function OnMouseOut(event:MouseEvent):void
		{
			OnMouseUp(event);
		}
		
		private function SaveMousePos():void
		{
			_mousePos[0] = this.mouseX;
			_mousePos[1] = this.mouseY;
		}
		
	}
}