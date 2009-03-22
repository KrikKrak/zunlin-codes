package com.zzl.flex.photoGallery.model
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	
	import mx.containers.Canvas;
	import mx.core.WindowedApplication;
	
	public class GlobeModelLocator extends EventDispatcher
	{
		public static const CAMERA_WIDTH:int = 160;
		public static const CAMERA_HEIGHT:int = 120;
		
		private static var _inst:GlobeModelLocator;
		
		public static function get inst():GlobeModelLocator
		{
			if (_inst == null)
			{
				_inst = new GlobeModelLocator(new GlobeModelLocatorCreator);
			}
			
			return _inst;
		}
		
		public function GlobeModelLocator(val:GlobeModelLocatorCreator){}
		
		
		//-------------------------------------------------------------------
		// _mainApplication
		private var _mainApplication:WindowedApplication;
		public function set mainApplication(val:WindowedApplication):void
		{
			_mainApplication = val;
		}
		public function get mainApplication():WindowedApplication
		{
			return _mainApplication;
		}
		
		//-------------------------------------------------------------------
		// _mainView
		private var _mainView:Canvas;
		public function set mainView(val:Canvas):void
		{
			_mainView = val;
		}
		public function get mainView():Canvas
		{
			return _mainView;
		}
		
		//-------------------------------------------------------------------
		// _drivenMode
		private var _drivenMode:String = DrivenMode.DRIVEN_MODE_MOUSE;
		public static const E_DRIVEN_MODE_UPDATE:String = "Event_DrivenModeUpdate";
		public function set drivenMode(val:String):void
		{
			_drivenMode = val;
			dispatchEvent(new Event(E_DRIVEN_MODE_UPDATE));
		}
		public function get drivenMode():String
		{
			return _drivenMode;
		}
		
		//-------------------------------------------------------------------
		// _projectionCenter
		private var _projectionCenter:Point;
		public static const E_PROJECTION_CENTER_UPDATE:String = "Event_ProjectionCenterUpdate";
		public function set projectionCenter(val:Point):void
		{
			_projectionCenter = val;
			dispatchEvent(new Event(E_PROJECTION_CENTER_UPDATE));
		}
		public function get projectionCenter():Point
		{
			return _projectionCenter;
		}
		
		//-------------------------------------------------------------------
		// _projectionDistance
		private var _projectionDistance:Number = 0;
		public static const E_PROJECTION_DISTANCE_UPDATE:String = "Event_ProjectionDistanceUpdate";
		public function set projectionDistance(val:Number):void
		{
			_projectionDistance = val;
			dispatchEvent(new Event(E_PROJECTION_DISTANCE_UPDATE));
		}
		public function get projectionDistance():Number
		{
			return _projectionDistance;
		}
		
		//-------------------------------------------------------------------
		// _cameraStatus
		private var _cameraStatus:String;
		public static const CAMERA_STATUS_ON:String = "CameraStatus_On";
		public static const CAMERA_STATUS_OFF:String = "CameraStatus_Off";
		public static const E_CAMERA_STATUS_UPDATE:String = "Event_CameraStatusUpdate";
		public function set cameraStatus(val:String):void
		{
			_cameraStatus = val;
			dispatchEvent(new Event(E_CAMERA_STATUS_UPDATE));
		}
		public function get cameraStatus():String
		{
			return _cameraStatus;
		}
		
		//-------------------------------------------------------------------
		// _cameraCanBeAccessed
		private var _cameraCanBeAccessed:Boolean = true;
		public static const E_CAMERA_CAN_BE_ACCESSED_UPDATE:String = "Event_CameraCanBeAccessedUpdate";
		public function set cameraCanBeAccessed(val:Boolean):void
		{
			_cameraCanBeAccessed = val;
			dispatchEvent(new Event(E_CAMERA_CAN_BE_ACCESSED_UPDATE));
		}
		public function get cameraCanBeAccessed():Boolean
		{
			return _cameraCanBeAccessed;
		}
		
		//-------------------------------------------------------------------
		// _showCameraWnd
		private var _showCameraWnd:Boolean = true;
		public static const E_SHOW_CAMERA_WND_UPDATE:String = "Event_ShowCameraWndUpdate";
		public function set showCameraWnd(val:Boolean):void
		{
			_showCameraWnd = val;
			dispatchEvent(new Event(E_SHOW_CAMERA_WND_UPDATE));
		}
		public function get showCameraWnd():Boolean
		{
			return _showCameraWnd;
		}
		
		//-------------------------------------------------------------------
		// _cameraBitmapData
		private var _cameraBitmapData:BitmapData;
		public static const E_CAMERA_BITMAPDATA_UPDATE:String = "Event_CameraBitmapDataUpdate";
		public function set cameraBitmapData(val:BitmapData):void
		{
			_cameraBitmapData = val;
			dispatchEvent(new Event(E_CAMERA_BITMAPDATA_UPDATE));
		}
		public function get cameraBitmapData():BitmapData
		{
			return _cameraBitmapData;
		}
		
		//-------------------------------------------------------------------
		// _detectBitmapData
		private var _detectBitmapData:BitmapData;
		public static const E_DETECT_BITMAPDATA_UPDATE:String = "Event_DetectBitmapDataUpdate";
		public function set detectBitmapData(val:BitmapData):void
		{
			_detectBitmapData = val;
			dispatchEvent(new Event(E_DETECT_BITMAPDATA_UPDATE));
		}
		public function get detectBitmapData():BitmapData
		{
			return _detectBitmapData;
		}
		
		//-------------------------------------------------------------------
		// _faceRects
		private var _faceRects:Array;
		public static const E_FACE_RECTS_UPDATE:String = "Event_FaceRectsUpdate";
		public function set faceRects(val:Array):void
		{
			_faceRects = val;
			dispatchEvent(new Event(E_FACE_RECTS_UPDATE));
		}
		public function get faceRects():Array
		{
			return _faceRects;
		}

	}
}

class GlobeModelLocatorCreator{}