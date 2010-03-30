package com.zzl.flex.photoGallery.model.commands
{
	public class SwitchCameraCommand
	{
		public static const C_SWITCH_CAMERA:String = "Command_SwitchCamera";
		
		public var cameraOn:Boolean;
		public var faceDetect:Boolean;
		
		public function SwitchCameraCommand(c:Boolean, f:Boolean = true)
		{
			cameraOn = c;
			faceDetect = f;
		}

	}
}