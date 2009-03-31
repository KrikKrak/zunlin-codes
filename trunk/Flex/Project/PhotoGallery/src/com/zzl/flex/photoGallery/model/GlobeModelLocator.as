package com.zzl.flex.photoGallery.model
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
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
		// _dataSource
		private var _dataSource:String = DATA_SOURCE_TEST;
		public static const DATA_SOURCE_TEST:String = "DataSource_Test";
		public static const DATA_SOURCE_LOCAL:String = "DataSource_Local";
		public static const DATA_SOURCE_RSS:String = "DataSource_Rss";
		public static const E_DATA_SOURCE_UPDATE:String = "Event_DataSourceUpdate";
		public function set dataSource(val:String):void
		{
			if (val != _dataSource)
			{
				_dataSource = val;
				dispatchEvent(new Event(E_DATA_SOURCE_UPDATE));
			}
		}
		public function get dataSource():String
		{
			return _dataSource;
		}
		
		//-------------------------------------------------------------------
		// _sourceLoadStatus
		private var _sourceLoadStatus:String = SOURCE_LOAD_IDLE;
		public static const SOURCE_LOAD_IDLE:String = "SourceLoad_Idle";
		public static const SOURCE_LOADING:String = "SourceLoading";
		public static const SOURCE_LOAD_FINISHED:String = "SourceLoad_Finished";
		public static const SOURCE_LOAD_ERROR:String = "SourceLoad_Error";
		public static const E_SOURCE_LOAD_STATUS_UPDATE:String = "Event_SourceLoadStatusUpdate";
		public function set sourceLoadStatus(val:String):void
		{
			_sourceLoadStatus = val;
			dispatchEvent(new Event(E_SOURCE_LOAD_STATUS_UPDATE));
		}
		public function get sourceLoadStatus():String
		{
			return _sourceLoadStatus;
		}
		
		//-------------------------------------------------------------------
		// _photoList
		private var _photoList:ArrayCollection;
		public static const E_PHOTO_LIST_UPDATE:String = "Event_PhotoListUpdate";
		public function set photoList(val:ArrayCollection):void
		{
			_photoList = val;
			dispatchEvent(new Event(E_PHOTO_LIST_UPDATE));
		}
		public function get photoList():ArrayCollection
		{
			return _photoList;
		}
		
		//-------------------------------------------------------------------
		// _entirLoadingProgress
		private var _entirLoadingProgress:int;
		public static const E_ENTIR_LOADING_PROGRESS_UPDATE:String = "Event_EntirLoadingProgressUpdate";
		public function set entirLoadingProgress(val:int):void
		{
			_entirLoadingProgress = val;
			dispatchEvent(new Event(E_ENTIR_LOADING_PROGRESS_UPDATE));
		}
		public function get entirLoadingProgress():int
		{
			return _entirLoadingProgress;
		}
		
		//-------------------------------------------------------------------
		// _drivenMode
		private var _drivenMode:String = DrivenMode.DRIVEN_MODE_MOUSE;
		public static const E_DRIVEN_MODE_UPDATE:String = "Event_DrivenModeUpdate";
		public function set drivenMode(val:String):void
		{
			if (val != _drivenMode)
			{
				_drivenMode = val;
				dispatchEvent(new Event(E_DRIVEN_MODE_UPDATE));
			}
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
		
		
		//-------------------------------------------------------------------
		// _sourceManageWndLoaded
		private var _sourceManageWndLoaded:Boolean = false;
		public static const E_SOURCE_MANAGE_WND_LOADED_UPDATE:String = "Event_SourceManageWndLoadedUpdate";
		public function set sourceManageWndLoaded(val:Boolean):void
		{
			_sourceManageWndLoaded = val;
			dispatchEvent(new Event(E_SOURCE_MANAGE_WND_LOADED_UPDATE));
		}
		public function get sourceManageWndLoaded():Boolean
		{
			return _sourceManageWndLoaded;
		}
		
		//-------------------------------------------------------------------
		// _localSourceDataArray
		private var _localSourceDataArray:ArrayCollection;
		public static const E_LOCAL_SOURCE_DATA_ARRAY_UPDATE:String = "Event_LocalSourceDataArrayUpdate";
		public function set localSourceDataArray(val:ArrayCollection):void
		{
			_localSourceDataArray = val;
			dispatchEvent(new Event(E_LOCAL_SOURCE_DATA_ARRAY_UPDATE));
		}
		public function get localSourceDataArray():ArrayCollection
		{
			return _localSourceDataArray;
		}
		
		//-------------------------------------------------------------------
		// _rssDataArray
		private var _rssDataArray:ArrayCollection;
		public static const E_RSS_DATA_ARRAY_UPDATE:String = "Event_RssDataArrayUpdate";
		public function set rssDataArray(val:ArrayCollection):void
		{
			_rssDataArray = val;
			dispatchEvent(new Event(E_RSS_DATA_ARRAY_UPDATE));
		}
		public function get rssDataArray():ArrayCollection
		{
			return _rssDataArray;
		}

	}
}

class GlobeModelLocatorCreator{}