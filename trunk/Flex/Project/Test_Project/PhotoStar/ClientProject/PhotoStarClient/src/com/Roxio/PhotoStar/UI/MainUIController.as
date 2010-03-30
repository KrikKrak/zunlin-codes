package com.Roxio.PhotoStar.UI
{
	import com.Roxio.OnlineObject.DebugTool.TraceTool;
	import com.Roxio.PhotoStar.Mode.GlobeSetting;
	import com.Roxio.PhotoStar.Mode.TargetLoadEvent;
	import com.Roxio.PhotoStar.Mode.TargetLoadMethod;
	import com.Roxio.PhotoStar.Server.DataController;
	import com.Roxio.PhotoStar.UI.CommonComponent.ProgressAnimation;
	import com.Roxio.PhotoStar.UI.EditPanel.ImageHolder;
	
	import flash.geom.Point;
	
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.core.UIComponent;
	import mx.events.CloseEvent;
	
	public class MainUIController
	{
		private static var _mainPage:MainPage;
		private static var _dataController:DataController;
		
		private static var _progressAnim:ProgressAnimation;
		
		public function MainUIController()
		{
			super();
		}
		
		public static function set mainPage(mp:MainPage):void
		{
			_mainPage = mp;
		}
		
		public static function showEditPanel():void
		{
			if (_mainPage != null)
			{
				_mainPage.left_panel.showEditPanel();
			}
		}
		
		public static function showImportPanel():void
		{
			if (_mainPage != null)
			{
				_mainPage.left_panel.showImportPanel();
			}
		}
		
		public static function addAdjustAreaPanel(uic:UIComponent):void
		{
			if (_mainPage != null)
			{
				_mainPage.main_panel.addAdjustAreaPanel(uic);
			}
		}
		
		public static function removeAdjustAreaPanel(uic:UIComponent):void
		{
			if (_mainPage != null)
			{
				_mainPage.main_panel.removeAdjustAreaPanel(uic);
			}
		}
		
		public static function showNewTargetLoadingAnim(callBackFn:Function):void
		{
			if (_mainPage != null)
			{
				_mainPage.loadNewTarget(callBackFn);
			}
		}
		
		public static function get appWidth():Number
		{
			return Application.application.width;
		}
		
		public static function get appHeight():Number
		{
			return Application.application.height;
		}
		
		public static function get imageHolder():ImageHolder
		{
			if (_mainPage != null)
			{
				return _mainPage.main_panel.imageHolder;
			}
			return null;
		}
		
		public static function get imageHolderSize():Point
		{
			if (_mainPage != null)
			{
				return new Point(_mainPage.main_panel.imageHolderWidth, _mainPage.main_panel.imageHolderHeight);
			}
			return null;
		}
		
		public static function loadDemoPhoto():void
		{
			if (NeedSaveOldData() == false)
			{
				dataController.loadDemoImage();
			}
			else
			{
				GlobeSetting.nextTargetLoadMethod = TargetLoadMethod.DEMO;
				GlobeSetting.loadNextTarget = true;
			}
		}
		
		public static function showLoadingAnimation(show:Boolean = true):void
		{
			TraceTool.Trace("MainUIController -- showLoadingAnimation -- show: " + show.toString());
		}
		
		public static function showProgressAnimation(show:Boolean = true):void
		{
			TraceTool.Trace("MainUIController -- showProgressAnimation -- show: " + show.toString());
			if (show == true)
			{
				if (_progressAnim == null)
				{
					_progressAnim = new ProgressAnimation;
					_progressAnim.width = appWidth;
					_progressAnim.height = appHeight;
					_mainPage.addChild(_progressAnim);
				}
			}
			else
			{
				if (_progressAnim != null && _mainPage.contains(_progressAnim))
				{
					_mainPage.removeChild(_progressAnim)
					_progressAnim = null;
				}
			}
		}
		
		public static function updateProgressValue(val:Number):void
		{
			if (_progressAnim != null)
			{
				_progressAnim.updatePercent(val);
			}
		}
		
		public static function showWaitingAnimation(show:Boolean = true):void
		{
			TraceTool.Trace("MainUIController -- showWaitingAnimation -- show: " + show.toString());
		}
		
		private static function get dataController():DataController
		{
			if (_dataController == null)
			{
				_dataController = DataController.controller;
				
				_dataController.addEventListener(TargetLoadEvent.IMAGE_START_LOAD, OnDataImageStartLoad, false, 0, true);
				_dataController.addEventListener(TargetLoadEvent.IMAGE_LOADING, OnDataImageLoading, false, 0, true);
				_dataController.addEventListener(TargetLoadEvent.IMAGE_LOADED, OnDataImageLoaded, false, 0, true);
				_dataController.addEventListener(TargetLoadEvent.IMAGE_LOAD_ERROR, OnDataImageLoadError, false, 0, true);

				GlobeSetting.isDataLoad = true;
			}
			return _dataController;
		}
		
		private static function OnDataImageStartLoad(event:TargetLoadEvent):void
		{
			showProgressAnimation(true);
		}
		
		private static function OnDataImageLoading(event:TargetLoadEvent):void
		{
			updateProgressValue(event.loadPercent);
		}
		
		private static function OnDataImageLoaded(event:TargetLoadEvent):void
		{
			showProgressAnimation(false);
			LoadNewTarget();
		}
		
		private static function OnDataImageLoadError(event:TargetLoadEvent):void
		{
			TraceTool.TraceError("MainUIController -- OnDataImageLoadError -- Error text: " + event.errorText);
		}
		
		private static function LoadNewTarget():void
		{
			if (_mainPage != null && _dataController != null && _dataController.bitmapData != null)
			{
				_mainPage.main_panel.loadNewTarget(_dataController.bitmapData);
			}
		}
		
		private static function NeedSaveOldData():Boolean
		{
			if (_dataController == null)
			{
				return false;
			}
			else
			{
				if (_dataController.dataChanged == false)
				{
					return false;
				}
				else
				{
					Alert.show("Save the target?", "Save", Alert.YES | Alert.NO, null, OnSaveReturn);
					return true;
				}
			}
		}
		
		private static function OnSaveReturn(event:CloseEvent):void
		{
			if (event.detail == Alert.YES)
			{
				TraceTool.Trace("MainUIController -- OnSaveReturn -- Save the target");
				SaveOldTarget();
			}
			else
			{
				TraceTool.Trace("MainUIController -- OnSaveReturn -- Not save, load new target");
				ReLoadNewTarget();
			}
		}
		
		private static function ReLoadNewTarget():void
		{
			if (GlobeSetting.loadNextTarget == true)
			{
				switch (GlobeSetting.nextTargetLoadMethod)
				{
					case TargetLoadMethod.DEMO:
						dataController.loadDemoImage();
						break;
					
					case TargetLoadMethod.FILE:
						break;
					
					case TargetLoadMethod.URL:
						break;
					
					case TargetLoadMethod.NOTHING:
						break;
				}
				
				GlobeSetting.loadNextTarget = false;
			}
		}
		
		private static function SaveOldTarget():void
		{
			// May be we just show up the Export panel
		}

	}
}