package com.zzl.flex.photoGallery.controller
{
	import com.zzl.flex.photoGallery.business.MainServiceLocator;
	import com.zzl.flex.photoGallery.model.GlobeModelLocator;
	import com.zzl.flex.photoGallery.model.commands.*;
	import com.zzl.flex.photoGallery.view.SourceManageWnd;
	
	import mx.collections.ArrayCollection;
	

	public class MainController
	{
		private static var _inst:MainController;

		private var _modelLocator:GlobeModelLocator = GlobeModelLocator.inst;
		private var _cameraController:CameraController = CameraController.inst;
		private var _faceDetectorController:FaceDetectorController = FaceDetectorController.inst;
		private var _mainServiceLocator:MainServiceLocator = MainServiceLocator.inst;
		private var _dataLoaderController:DataLoaderController = DataLoaderController.inst;
		
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
					
				case ReadDataCommand.C_READ_DATA:
					ReadData(cParam as ReadDataCommand);
					break;
					
				case LoadSourceManageWndCommand.C_LOAD_SOURCE_MANAGE_WND:
					LoadSourceManageWnd(cParam as LoadSourceManageWndCommand);
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
		
		private function ReadData(c:ReadDataCommand):void
		{
			_modelLocator.sourceLoadStatus = GlobeModelLocator.SOURCE_LOADING;
			switch (c.dataSource)
			{
				case GlobeModelLocator.DATA_SOURCE_LOCAL:
					_mainServiceLocator.resolveLocalFolderPaths(SourceReadCallbackFn);
					break;
					
				case GlobeModelLocator.DATA_SOURCE_RSS:
					_mainServiceLocator.resolveRssPaths(SourceReadCallbackFn);
					break;
					
				case GlobeModelLocator.DATA_SOURCE_TEST:
					_mainServiceLocator.resolveTestFolderPaths(SourceReadCallbackFn);
					break;
			}
		}
		
		private function SourceReadCallbackFn(a:ArrayCollection):void
		{
			if (a.length > 0)
			{
				_dataLoaderController.readData(a);
			}
			else
			{
				_modelLocator.sourceLoadStatus = GlobeModelLocator.SOURCE_LOAD_ERROR;
			}
		}
		
		private function LoadSourceManageWnd(c:LoadSourceManageWndCommand):void
		{
			if (c.load == true)
			{
				if (_modelLocator.sourceManageWndLoaded == false)
				{
					var w:SourceManageWnd = new SourceManageWnd;
					_modelLocator.mainView.addChild(w);
					_modelLocator.sourceManageWndLoaded = true;
				}
			}
			else
			{
				if (_modelLocator.sourceManageWndLoaded == true)
				{
					if (_modelLocator.mainView.contains(c.self as SourceManageWnd))
					{
						_modelLocator.mainView.removeChild(c.self as SourceManageWnd);
						c.self = null;
					}
					_modelLocator.sourceManageWndLoaded = false;
				}
			}
		}
		
	}
}

class MainControllerCreator{}