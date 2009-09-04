package com.zzl.flex.LogUrFeeling.Model
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.core.UIComponent;
	
	public class MainModelLocator extends EventDispatcher
	{
		private static var _inst:MainModelLocator;
		
		private var _isDebug:Boolean = true;

		static public function get inst():MainModelLocator
		{
			if (_inst == null)
			{
				_inst = new MainModelLocator(new MainModelLocatorConstrctor);
			}
			
			return _inst;
		}
		
		public function MainModelLocator(val:MainModelLocatorConstrctor)
		{}
		
		public function initInputParam(param:Object):void
		{
			if (_isDebug == false)
			{
				if (param.enableLog == false)
				{
					isLogEnable = false;
				}
				if (param.enableStatic == false)
				{
					isStaticsEnable = false;
				}
				if (param.enableHistory == false)
				{
					isHistoryEnable = false;
				}
				if (param.enableAbout == false)
				{
					isAboutEnable = false;
				}
				userIp = param.userIp;
				submitServiceUrl = param.submitServiceUrl;
				queryServiceUrl = param.queryServiceUrl;
			}
			else
			{
				isLogEnable = true;
				isStaticsEnable = true;
				isHistoryEnable = true;
				isAboutEnable = true;
				userIp = "localhost";
				submitServiceUrl = "http://localhost:8083/submittest";
				queryServiceUrl = "";
			}
		}
		
		//-------------------------------------------------------------------
		// _applicationContainer
		private var _applicationContainer:UIComponent;
		public static const E_APPLICATION_CONTAINER_UPDATE:String = "Event_ApplicationContainerUpdate";
		public function set applicationContainer(val:UIComponent):void
		{
			_applicationContainer = val;
			dispatchEvent(new Event(E_APPLICATION_CONTAINER_UPDATE));
		}
		public function get applicationContainer():UIComponent
		{
			return _applicationContainer;
		}
		
		//-------------------------------------------------------------------
		// _mainFrame
		private var _mainFrame:UIComponent;
		public static const E_MAIN_FRAME_UPDATE:String = "Event_MainFrameUpdate";
		public function set mainFrame(val:UIComponent):void
		{
			_mainFrame = val;
			dispatchEvent(new Event(E_MAIN_FRAME_UPDATE));
		}
		public function get mainFrame():UIComponent
		{
			return _mainFrame;
		}
		
		//-------------------------------------------------------------------
		// _userIp
		private var _userIp:String;
		public static const E_USER_IP_UPDATE:String = "Event_UserIpUpdate";
		public function set userIp(val:String):void
		{
			_userIp = val;
			dispatchEvent(new Event(E_USER_IP_UPDATE));
		}
		public function get userIp():String
		{
			return _userIp;
		}
		
		//-------------------------------------------------------------------
		// _submitServiceUrl
		private var _submitServiceUrl:String;
		public static const E_SUBMIT_SERVICE_URL_UPDATE:String = "Event_SubmitServiceUrlUpdate";
		public function set submitServiceUrl(val:String):void
		{
			_submitServiceUrl = val;
			dispatchEvent(new Event(E_SUBMIT_SERVICE_URL_UPDATE));
		}
		public function get submitServiceUrl():String
		{
			return _submitServiceUrl;
		}
		
		//-------------------------------------------------------------------
		// _queryServiceUrl
		private var _queryServiceUrl:String;
		public static const E_QUERY_SERVICE_URL_UPDATE:String = "Event_QueryServiceUrlUpdate";
		public function set queryServiceUrl(val:String):void
		{
			_queryServiceUrl = val;
			dispatchEvent(new Event(E_QUERY_SERVICE_URL_UPDATE));
		}
		public function get queryServiceUrl():String
		{
			return _queryServiceUrl;
		}
		
		//-------------------------------------------------------------------
		// _isLogEnable
		private var _isLogEnable:Boolean = true;
		public static const E_IS_LOG_ENABLE_UPDATE:String = "Event_IsLogEnableUpdate";
		public function set isLogEnable(val:Boolean):void
		{
			_isLogEnable = val;
			dispatchEvent(new Event(E_IS_LOG_ENABLE_UPDATE));
		}
		public function get isLogEnable():Boolean
		{
			return _isLogEnable;
		}
		
		//-------------------------------------------------------------------
		// _isStaticsEnable
		private var _isStaticsEnable:Boolean = true;
		public static const E_IS_STATICS_ENABLE_UPDATE:String = "Event_IsStaticsEnableUpdate";
		public function set isStaticsEnable(val:Boolean):void
		{
			_isStaticsEnable = val;
			dispatchEvent(new Event(E_IS_STATICS_ENABLE_UPDATE));
		}
		public function get isStaticsEnable():Boolean
		{
			return _isStaticsEnable;
		}
		
		//-------------------------------------------------------------------
		// _isHistoryEnable
		private var _isHistoryEnable:Boolean = true;
		public static const E_IS_HISTORY_ENABLE_UPDATE:String = "Event_IsHistoryEnableUpdate";
		public function set isHistoryEnable(val:Boolean):void
		{
			_isHistoryEnable = val;
			dispatchEvent(new Event(E_IS_HISTORY_ENABLE_UPDATE));
		}
		public function get isHistoryEnable():Boolean
		{
			return _isHistoryEnable;
		}
		
		//-------------------------------------------------------------------
		// _isAboutEnable
		private var _isAboutEnable:Boolean = true;
		public static const E_IS_ABOUT_ENABLE_UPDATE:String = "Event_IsAboutEnableUpdate";
		public function set isAboutEnable(val:Boolean):void
		{
			_isAboutEnable = val;
			dispatchEvent(new Event(E_IS_ABOUT_ENABLE_UPDATE));
		}
		public function get isAboutEnable():Boolean
		{
			return _isAboutEnable;
		}
		
		//-------------------------------------------------------------------
		// _aboutPageTitle
		private var _aboutPageTitle:String;
		public static const E_ABOUT_PAGE_TITLE_UPDATE:String = "Event_AboutPageTitleUpdate";
		public function set aboutPageTitle(val:String):void
		{
			_aboutPageTitle = val;
			dispatchEvent(new Event(E_ABOUT_PAGE_TITLE_UPDATE));
		}
		public function get aboutPageTitle():String
		{
			return _aboutPageTitle;
		}
		
		//-------------------------------------------------------------------
		// _logFeelingModuleUrl
		private var _logFeelingModuleUrl:String = "com/zzl/flex/LogUrFeeling/view/LogFeeling.swf";
		public static const E_LOG_FEELING_MODULE_URL_UPDATE:String = "Event_LogFeelingModuleUrlUpdate";
		public function set logFeelingModuleUrl(val:String):void
		{
			_logFeelingModuleUrl = val;
			dispatchEvent(new Event(E_LOG_FEELING_MODULE_URL_UPDATE));
		}
		public function get logFeelingModuleUrl():String
		{
			return _logFeelingModuleUrl;
		}
		
		//-------------------------------------------------------------------
		// _staticsModuleUrl
		private var _staticsModuleUrl:String = "";
		public static const E_STATICS_MODULE_URL_UPDATE:String = "Event_StaticsModuleUrlUpdate";
		public function set staticsModuleUrl(val:String):void
		{
			_staticsModuleUrl = val;
			dispatchEvent(new Event(E_STATICS_MODULE_URL_UPDATE));
		}
		public function get staticsModuleUrl():String
		{
			return _staticsModuleUrl;
		}
		
		//-------------------------------------------------------------------
		// _historyModuleUrl
		private var _historyModuleUrl:String = "";
		public static const E_HISTORY_MODULE_URL_UPDATE:String = "Event_HistoryModuleUrlUpdate";
		public function set historyModuleUrl(val:String):void
		{
			_historyModuleUrl = val;
			dispatchEvent(new Event(E_HISTORY_MODULE_URL_UPDATE));
		}
		public function get historyModuleUrl():String
		{
			return _historyModuleUrl;
		}
		
		//-------------------------------------------------------------------
		// _aboutModuleUrl
		private var _aboutModuleUrl:String = "com/zzl/flex/LogUrFeeling/view/AboutPage.swf";
		public static const E_ABOUT_MODULE_URL_UPDATE:String = "Event_AboutModuleUrlUpdate";
		public function set aboutModuleUrl(val:String):void
		{
			_aboutModuleUrl = val;
			dispatchEvent(new Event(E_ABOUT_MODULE_URL_UPDATE));
		}
		public function get aboutModuleUrl():String
		{
			return _aboutModuleUrl;
		}
		
		//-------------------------------------------------------------------
		// _moduleLoadStart
		private var _moduleLoadStart:Boolean;
		public static const E_MODULE_LOAD_START_UPDATE:String = "Event_ModuleLoadStartUpdate";
		public function set moduleLoadStart(val:Boolean):void
		{
			_moduleLoadStart = val;
			dispatchEvent(new Event(E_MODULE_LOAD_START_UPDATE));
			
			_moduleLoadReady = false
			_moduleLoadError = false;
		}
		public function get moduleLoadStart():Boolean
		{
			return _moduleLoadStart;
		}
		
		//-------------------------------------------------------------------
		// _moduleLoadReady
		private var _moduleLoadReady:Boolean;
		public static const E_MODULE_LOAD_READY_UPDATE:String = "Event_ModuleLoadReadyUpdate";
		public function set moduleLoadReady(val:Boolean):void
		{
			_moduleLoadReady = val;
			dispatchEvent(new Event(E_MODULE_LOAD_READY_UPDATE));
			
			_moduleLoadError = false;
			_moduleLoadStart = false;
		}
		public function get moduleLoadReady():Boolean
		{
			return _moduleLoadReady;
		}
		
		//-------------------------------------------------------------------
		// _moduleLoadError
		private var _moduleLoadError:Boolean;
		public static const E_MODULE_LOAD_ERROR_UPDATE:String = "Event_ModuleLoadErrorUpdate";
		public function set moduleLoadError(val:Boolean):void
		{
			_moduleLoadError = val;
			dispatchEvent(new Event(E_MODULE_LOAD_ERROR_UPDATE));
			
			_moduleLoadStart = false;
			_moduleLoadReady = false;
		}
		public function get moduleLoadError():Boolean
		{
			return _moduleLoadError;
		}
		
		//-------------------------------------------------------------------
		// _moduleLoadProgress
		private var _moduleLoadProgress:int;
		public static const E_MODULE_LOAD_PROGRESS_UPDATE:String = "Event_ModuleLoadProgressUpdate";
		public function set moduleLoadProgress(val:int):void
		{
			_moduleLoadProgress = val;
			dispatchEvent(new Event(E_MODULE_LOAD_PROGRESS_UPDATE));
		}
		public function get moduleLoadProgress():int
		{
			return _moduleLoadProgress;
		}

		//-------------------------------------------------------------------
		// _useAnimPageSwitch
		private var _useAnimPageSwitch:Boolean = true;;
		public static const E_USE_ANIM_PAGE_SWITCH_UPDATE:String = "Event_UseAnimPageSwitchUpdate";
		public function set useAnimPageSwitch(val:Boolean):void
		{
			_useAnimPageSwitch = val;
			dispatchEvent(new Event(E_USE_ANIM_PAGE_SWITCH_UPDATE));
		}
		public function get useAnimPageSwitch():Boolean
		{
			return _useAnimPageSwitch;
		}

		//-------------------------------------------------------------------
		// _feelingLogged
		private var _feelingLogged:Boolean = false;
		public static const E_FEELING_LOGGED_UPDATE:String = "Event_FeelingLoggedUpdate";
		public function set feelingLogged(val:Boolean):void
		{
			_feelingLogged = val;
			dispatchEvent(new Event(E_FEELING_LOGGED_UPDATE));
		}
		public function get feelingLogged():Boolean
		{
			return _feelingLogged;
		}

	}
}

class MainModelLocatorConstrctor
{}