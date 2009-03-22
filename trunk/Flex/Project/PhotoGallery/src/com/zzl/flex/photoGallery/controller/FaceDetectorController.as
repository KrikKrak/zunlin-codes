package com.zzl.flex.photoGallery.controller
{
	import com.zzl.flex.photoGallery.model.GlobeModelLocator;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import jp.maaash.ObjectDetection.ObjectDetector;
	import jp.maaash.ObjectDetection.ObjectDetectorEvent;
	import jp.maaash.ObjectDetection.ObjectDetectorOptions;
	
	public class FaceDetectorController
	{
		private static var _inst:FaceDetectorController;
		
		private var _modelLocator:GlobeModelLocator = GlobeModelLocator.inst;
		private var _detector:ObjectDetector;
		private var _previousDetectEnd:Boolean = true;
		
		public static function get inst():FaceDetectorController
		{
			if (_inst == null)
			{
				_inst = new FaceDetectorController(new FaceDetectorControllerCreator);
				_inst.InitFaceDetector();
			}
			
			return _inst;
		}
		
		public function FaceDetectorController(val:FaceDetectorControllerCreator){}
		
		private function InitFaceDetector():void
		{
			_detector = new ObjectDetector;
			_detector.options = new ObjectDetectorOptions;
			_detector.addEventListener(ObjectDetectorEvent.DETECTION_COMPLETE, OnDetectorEnd, false, 0, true);
		}
		
		public function startDetect():void
		{
			_modelLocator.addEventListener(GlobeModelLocator.E_DETECT_BITMAPDATA_UPDATE, OnDetectBitmapDataUpdate, false, 0, true);
		}
		
		public function endDetect():void
		{
			_modelLocator.removeEventListener(GlobeModelLocator.E_DETECT_BITMAPDATA_UPDATE, OnDetectBitmapDataUpdate);
		}
		
		public function detect(bd:BitmapData):void
		{
			_detector.detect(bd);
		}
		
		private function OnDetectBitmapDataUpdate(e:Event):void
		{
			if (_previousDetectEnd == true)
			{
				_previousDetectEnd = false;
				_detector.detect(_modelLocator.detectBitmapData);
			}
		}
		
		private function OnDetectorEnd(e:ObjectDetectorEvent):void
		{
			_modelLocator.faceRects = e.rects;
			_previousDetectEnd = true;
		}

	}
}

class FaceDetectorControllerCreator{}