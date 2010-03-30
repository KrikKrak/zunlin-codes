package com.zzl.flex.photoGallery.controller
{
	import com.quasimondo.bitmapdata.CameraBitmap;
	import com.zzl.flex.photoGallery.model.GlobeModelLocator;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.media.Camera;
	
	public class CameraController
	{
		private static var _inst:CameraController;
		
		private var _modelLocator:GlobeModelLocator = GlobeModelLocator.inst;
		
		private var _cameraBitmap:CameraBitmap;
		
		public static function get inst():CameraController
		{
			if (_inst == null)
			{
				_inst = new CameraController(new CameraControllerCreator);
			}
			
			return _inst;
		}
		
		public function CameraController(val:CameraControllerCreator){}
		
		public function initCamera():void
		{
			if (Camera.names.length > 0)
			{
				_cameraBitmap = new CameraBitmap(GlobeModelLocator.CAMERA_WIDTH, GlobeModelLocator.CAMERA_HEIGHT);
				_cameraBitmap.addEventListener(CameraBitmap.E_CAMERA_RENDER, OnCameraRender, false, 0, true);
				_modelLocator.cameraBitmapData = _cameraBitmap.bitmapData;
				_modelLocator.cameraCanBeAccessed = true;
			}
			else
			{
				_modelLocator.cameraCanBeAccessed = false;
			}
		}
		
		public function closeCamera():void
		{
			CleanUp();
			_modelLocator.cameraBitmapData = null;
			_modelLocator.cameraCanBeAccessed = false;
		}
		
		public function get cameraContent():BitmapData
		{
			if (_cameraBitmap != null && _modelLocator.cameraCanBeAccessed == true)
			{
				return _cameraBitmap.bitmapData;
			}
			else
			{
				return null;
			}
		}
		
		private function OnCameraRender(e:Event):void
		{
			var bd:BitmapData = new BitmapData(GlobeModelLocator.CAMERA_WIDTH, GlobeModelLocator.CAMERA_HEIGHT, false);
			bd.draw(_cameraBitmap.bitmapData);
			_modelLocator.detectBitmapData = bd;
		}
		
		private function CleanUp():void
		{
			if (_cameraBitmap != null)
			{
				_cameraBitmap.removeEventListener(CameraBitmap.E_CAMERA_RENDER, OnCameraRender);
				_cameraBitmap.close();
				_cameraBitmap = null;
			}
		}
	}
}

class CameraControllerCreator{}