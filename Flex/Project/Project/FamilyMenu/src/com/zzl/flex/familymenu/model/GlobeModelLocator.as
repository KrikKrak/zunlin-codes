package com.zzl.flex.familymenu.model
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.core.WindowedApplication;
	
	public class GlobeModelLocator extends EventDispatcher
	{
		private static var _inst:GlobeModelLocator;
		public static const VERSION:String = "1.0";
		public static const CHINESE_ALL_WORD:String = "全部";
		public static const SPRING:String = "春";
		public static const SUMMER:String = "夏";
		public static const FALL:String = "秋";
		public static const WINTER:String = "冬";
		public static const HOT:String = "辣";
		public static const NOTHOT:String = "不辣";
		
		public static function get inst():GlobeModelLocator
		{
			if (_inst == null)
			{
				_inst = new GlobeModelLocator(new GlobeModelLocatorCreator);
			}
			
			return _inst;
		}
		
		public static function get hotArray():ArrayCollection
		{
			var a:ArrayCollection = new ArrayCollection;
			a.addItem(HOT);
			a.addItem(NOTHOT);
			return a;
		}
		
		public static function get seasonsArray():ArrayCollection
		{
			var a:ArrayCollection = new ArrayCollection;
			a.addItem(SPRING);
			a.addItem(SUMMER);
			a.addItem(FALL);
			a.addItem(WINTER);
			return a;
		}
		
		public function GlobeModelLocator(val:GlobeModelLocatorCreator){}
		
		
		//-------------------------------------------------------------------
		// _mainApplication
		private var _mainApplication:WindowedApplication;
		
		public function set mainApplication(val:WindowedApplication):void
		{
			_mainApplication = val;
			InitAppStatus();
		}
		
		public function get mainApplication():WindowedApplication
		{
			return _mainApplication;
		}
		
		//-------------------------------------------------------------------
		// _mainFrame
		private var _mainFrame:Canvas;
		
		public function set mainFrame(val:Canvas):void
		{
			_mainFrame = val;
		}
		
		public function get mainFrame():Canvas
		{
			return _mainFrame;
		}
		
		//-------------------------------------------------------------------
		// _dishs
		private var _dishs:ArrayCollection = new ArrayCollection;
		public static const E_DISHS_UPDATE:String = "DishsUpdateEvent";
		
		public function set dishs(val:ArrayCollection):void
		{
			_dishs = val;
			dispatchEvent(new Event(E_DISHS_UPDATE));
		}
		
		public function get dishs():ArrayCollection
		{
			return _dishs;
		}
		
		//-------------------------------------------------------------------
		// _curDish
		private var _curDish:DishDetail;
		
		public function set curDish(val:DishDetail):void
		{
			_curDish = val;
		}
		
		public function get curDish():DishDetail
		{
			return _curDish;
		}
		
		//-------------------------------------------------------------------
		// _isNewDishShowUp
		private var _isNewDishShowUp:Boolean = false;
		public static const E_NEW_DISH_SHOW_UP:String = "NewDishShowUpEvent";
		
		public function set isNewDishShowUp(val:Boolean):void
		{
			_isNewDishShowUp = val;
			dispatchEvent(new Event(E_NEW_DISH_SHOW_UP));
		}
		
		public function get isNewDishShowUp():Boolean
		{
			return _isNewDishShowUp;
		}
		
		//-------------------------------------------------------------------
		// _newDishViewModel
		private var _newDishViewModel:String = NEW_DISK_VIEW_MODEL_CREATE;
		public static const NEW_DISK_VIEW_MODEL_CREATE:String = "NewDishViewModelCreate";
		public static const NEW_DISK_VIEW_MODEL_MODIFY:String = "NewDishViewModelModify";
		
		public function set newDishViewModel(val:String):void
		{
			_newDishViewModel = val;
		}
		
		public function get newDishViewModel():String
		{
			return _newDishViewModel;
		}
		
		//-------------------------------------------------------------------
		// _appMinWidth
		private var _appMinWidth:int;
		
		public function set appMinWidth(val:int):void
		{
			_appMinWidth = val;
		}
		
		public function get appMinWidth():int
		{
			return _appMinWidth;
		}
		
		//-------------------------------------------------------------------
		// _appMinHeight
		private var _appMinHeight:int;
		
		public function set appMinHeight(val:int):void
		{
			_appMinHeight = val;
		}
		
		public function get appMinHeight():int
		{
			return _appMinHeight;
		}
		
	
		//--------------------------------------------------------------------
		// Inner use function
		private function InitAppStatus():void
		{
			appMinWidth = mainApplication.minWidth;
			appMinHeight = mainApplication.minHeight;
		}
		
		//-------------------------------------------------------------------
		// _isSimpleSearchShowUp
		private var _isSimpleSearchShowUp:Boolean = false;
		public static const E_SIMPLE_SEARCH_SHOW_UP:String = "SimpleSearchShowUpEvent";
		
		public function set isSimpleSearchShowUp(val:Boolean):void
		{
			_isSimpleSearchShowUp = val;
			dispatchEvent(new Event(E_SIMPLE_SEARCH_SHOW_UP));
		}
		
		public function get isSimpleSearchShowUp():Boolean
		{
			return _isSimpleSearchShowUp;
		}
		
		//-------------------------------------------------------------------
		// _isSimpleSearchShowUp
		private var _simpleSearchResult:DishDetail;
		public static const E_SIMPLE_SEARCH_RESULT:String = "SimpleSearchResultEvent";
		
		public function set simpleSearchResult(val:DishDetail):void
		{
			_simpleSearchResult = val;
			dispatchEvent(new Event(E_SIMPLE_SEARCH_RESULT));
		}
		
		public function get simpleSearchResult():DishDetail
		{
			return _simpleSearchResult;
		}
	}
}

class GlobeModelLocatorCreator{}