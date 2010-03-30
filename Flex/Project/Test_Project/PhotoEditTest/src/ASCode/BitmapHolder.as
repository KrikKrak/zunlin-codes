package ASCode
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import mx.core.UIComponent;

	public class BitmapHolder extends UIComponent
	{
		private var _bitmap:Bitmap;
		
		public function BitmapHolder(bitmap:Bitmap, bitmapdata:BitmapData = null)
		{
			super();
			
			if (bitmap == null && bitmapdata != null)
			{
				_bitmap = new Bitmap(bitmapdata);
			}
			else if (bitmap != null)
			{
				_bitmap = bitmap;
			}
		}
		
		public function get bitmap():Bitmap
		{
			return _bitmap;
		}
		
		public function releaseData():void
		{
			if (_bitmap != null)
			{
				_bitmap.bitmapData.dispose();
			}
		}
		
		override protected function createChildren():void
        {
            super.createChildren();
            addChild(_bitmap);
        }

        override public function set width(value:Number):void
        {
            super.width = value;
            UpdateBitmapSize();
        }

        override public function get width():Number
        {
            return super.width;
        }

        override public function set height(value:Number):void
        {
            super.height = value;
            UpdateBitmapSize();
        }

        override public function get height():Number
        {
            return super.height;
        }
        
        private function UpdateBitmapSize():void
        {
        	if (_bitmap != null)
        	{
        		_bitmap.x = 0;
        		_bitmap.y = 0;
        		_bitmap.width = this.width;
        		_bitmap.height = this.height;
        	}
        }
	}
}