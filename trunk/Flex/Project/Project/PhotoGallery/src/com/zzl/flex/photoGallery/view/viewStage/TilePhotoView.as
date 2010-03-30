package com.zzl.flex.photoGallery.view.viewStage
{
	import com.zzl.flex.photoGallery.view.photoStage.CommonPhotoStage;
		
	public class TilePhotoView extends CommonViewStage
	{
		protected var BORDER_GAP:int = 20;
		protected var INTERVAL_GAP:int = 10;
		
		public function TilePhotoView()
		{
			super();
			
			//PHOTO_WIDTH = 320;
			//PHOTO_HEIGHT = 240;
		}
		
		override protected function UpdatePhotoPosition():void
		{
			var xStart:int = BORDER_GAP;
			var yStart:int = BORDER_GAP;
			
			for each (var pc:CommonPhotoStage in _photoChildren)
			{
				pc.x = xStart;
				pc.y = yStart;
				
				xStart += PHOTO_WIDTH + INTERVAL_GAP;
				if (xStart + PHOTO_WIDTH + BORDER_GAP > this.width)
				{
					xStart = BORDER_GAP;
					yStart += PHOTO_HEIGHT + INTERVAL_GAP;
				}
			}
		}
	}
}