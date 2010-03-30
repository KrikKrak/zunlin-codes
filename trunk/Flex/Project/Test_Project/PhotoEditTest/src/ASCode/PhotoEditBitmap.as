package ASCode
{
	import PEUIComponent.IDragPanel;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.UIComponent;
	
	[Event(name="event_DataChange",type="flash.events.Event")]
	[Event(name="event_DataMove",type="flash.events.Event")]

	public class PhotoEditBitmap extends UIComponent
											implements IDragPanel
	{
		private var mBitmap:Bitmap;
		private var mOriWidth:Number;
		private var mOriHeight:Number;
		private var mOriScaleX:Number;
		private var mOriScaleY:Number;
		private var mCurScale:Number = 1;

		public function PhotoEditBitmap(bitmapData:BitmapData)
		{
			super();

			mBitmap = new Bitmap(bitmapData);
			mBitmap.x = 0;
			mBitmap.y = 0;
			mBitmap.smoothing = true;
			mOriWidth = mBitmap.width;
			mOriHeight = mBitmap.height;
			mOriScaleX = mBitmap.scaleX;
			mOriScaleY = mBitmap.scaleY;
		}
		
		public function IsMouseOver(mx:Number, my:Number):Boolean
		{
			return this.hitTestPoint(mx, my, false);
		}
		
		public function CanDrag(mx:Number, my:Number):Boolean
		{
			return true;
		}
		
		public function ChangDragPos(xOffset:Number, yOffset:Number):void
		{
			if (mBitmap.x + xOffset < 0 && mBitmap.x + mBitmap.width + xOffset > this.width)
			{
				mBitmap.x += xOffset;
			}
			if (mBitmap.y + yOffset < 0 && mBitmap.y + mBitmap.height + yOffset > this.height)
			{
				mBitmap.y += yOffset;
			}
			dispatchEvent(new Event("event_DataMove"));
		}
		
		public function get moveable():Boolean
		{
			return true;
		}

		public function SetWH(width:Number, height:Number):void
		{
			super.width = width;
			super.height = height;
			CalcBitmapSize();
		}
		
		public function get bitmap():Bitmap
		{
			return mBitmap;
		}
		
		public function get bitmapData():BitmapData
		{
			return mBitmap.bitmapData;
		}
		
		public function get dataGlobalRect():Rectangle
		{
			var gStartPos:Point = this.localToGlobal(new Point(mBitmap.x, mBitmap.y));
			return new Rectangle(gStartPos.x, gStartPos.y, mBitmap.width, mBitmap.height);
		}

		override protected function createChildren():void
        {
            super.createChildren();
            addChild(mBitmap);
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
        
        public function get bitmapScaleX():Number
        {
        	return mBitmap.scaleX;
        }
        
        public function get bitmapScaleY():Number
        {
        	return mBitmap.scaleY;
        }
        
        public function RemoveUnusedChild():void
        {
        	while (this.numChildren > 1)
        	{
        		this.removeChildAt(this.numChildren - 1);
        	}
        }

        public function ResetBitmap():void
        {
        	this.width = mOriWidth;
        	this.height = mOriHeight;
        	mOriScaleX = mBitmap.scaleX;
			mOriScaleY = mBitmap.scaleY;
        }

        public function SetSize(nu:Number):void
        {
        	mBitmap.scaleX = mOriScaleX * nu;
        	mBitmap.scaleY = mOriScaleY * nu;
        }
        
        public function SetScale(nu:Number):void
        {
        	PutBitmapOriPos(nu);
        	mBitmap.scaleX = nu;
        	mBitmap.scaleY = nu;

        	if (mBitmap.x > 0 && mBitmap.width > this.width)
        	{
        		mBitmap.x = 0;
        	}
        	
        	if (mBitmap.x + mBitmap.width < this.width && mBitmap.width > this.width)
        	{
        		mBitmap.x = this.width - mBitmap.width;
        	}
        	
        	if (mBitmap.width <= this.width)
        	{
        		mBitmap.x = (this.width - mBitmap.width) / 2;
        	}
        	
        	if (mBitmap.y > 0 && mBitmap.height > this.height)
        	{
        		mBitmap.y = 0;
        	}
        	
        	if (mBitmap.y + mBitmap.height < this.height && mBitmap.height > this.height)
        	{
        		mBitmap.y = this.height - mBitmap.height;
        	}
        	
        	if (mBitmap.height <= this.height)
        	{
        		mBitmap.y = (this.height - mBitmap.height) / 2;
        	}
        }

        public function ChangeBitmapData(bitmapData:BitmapData):void
        {
        	mBitmap.bitmapData = bitmapData.clone();
			mBitmap.x = 0;
			mBitmap.y = 0;
			mBitmap.smoothing = true;
			mOriWidth = bitmapData.width;
			mOriHeight = bitmapData.height;

			// set to cur MyBitmap size
			CalcBitmapSize();
			
			dispatchEvent(new Event("event_DataChange"));
        }
        
        public function ApplyBitmapData(bitmapData:BitmapData):void
        {
        	// just change the bitmap data without renew it's size and pos
        	mBitmap.bitmapData = bitmapData;
        }

        public function IsReady():Boolean
        {
        	return (mBitmap != null);
        }

        public function GetRatioWH():Number
        {
        	return (mOriWidth / mOriHeight);
        }

        private function CalcBitmapSize():void
        {
        	var ratio:Number = GetRatioWH();
			if (ratio > this.width / this.height)
			{
				mBitmap.x = 0;
				mBitmap.y = (this.height - this.width / ratio) / 2;
				mBitmap.width = this.width;
            	mBitmap.height = mBitmap.width / ratio;
			}
			else
			{
				mBitmap.x = (this.width - this.height * ratio) / 2;;
				mBitmap.y = 0;
				mBitmap.height = this.height;
	            mBitmap.width = mBitmap.height * ratio;
			}

        	mOriScaleX = mBitmap.scaleX;
			mOriScaleY = mBitmap.scaleY;
        }
        
        private function PutBitmapCenter():void
        {
        	mBitmap.x = (this.width - mBitmap.width) / 2;
			mBitmap.y = (this.height - mBitmap.height) / 2;
        }
        
        private function PutBitmapOriPos(newScale:Number):void
        {
        	var oriScale:Number = mBitmap.scaleX;
        	var centerX:Number = this.width / 2;
        	var centerY:Number = this.height / 2;
        	mBitmap.x = centerX - ((centerX - mBitmap.x) * newScale / oriScale);
        	mBitmap.y = centerY - ((centerY - mBitmap.y) * newScale / oriScale);
        }

	}
}