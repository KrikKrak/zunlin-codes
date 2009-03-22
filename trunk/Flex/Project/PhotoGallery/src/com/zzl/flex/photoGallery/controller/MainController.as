package com.zzl.flex.photoGallery.controller
{
	import com.zzl.flex.photoGallery.model.GlobeModelLocator;
	import com.zzl.flex.photoGallery.model.commands.*;
	

	public class MainController
	{
		private static var _inst:MainController;

		private var _modelLocator:GlobeModelLocator = GlobeModelLocator.inst;
		private var _cameraController:CameraController = CameraController.inst;
		private var _faceDetectorController:FaceDetectorController = FaceDetectorController.inst;
		
		public static function get inst():MainController
		{
			if (_inst == null)
			{
				_inst = new MainController(new MainControllerCreator);
			}
			
			return _inst;
		}
		
		public function MainController(val:MainControllerCreator){}
		
		public function handleCommand(cName:String, cParam:Object = null):void
		{
			switch(cName)
			{
				case SwitchCameraCommand.C_SWITCH_CAMERA:
					SwitchCamera(cParam as SwitchCameraCommand);
					break;
			}
		}

		private function SwitchCamera(c:SwitchCameraCommand):void
		{
			_modelLocator.cameraStatus = (c.cameraOn == true) ? GlobeModelLocator.CAMERA_STATUS_ON : GlobeModelLocator.CAMERA_STATUS_OFF;
			if (c.cameraOn == true)
			{
				_cameraController.initCamera();
				_faceDetectorController.startDetect();
			}
			else
			{
				_cameraController.closeCamera();
				_faceDetectorController.endDetect();
			}
		}
		
	}
}

class MainControllerCreator{}