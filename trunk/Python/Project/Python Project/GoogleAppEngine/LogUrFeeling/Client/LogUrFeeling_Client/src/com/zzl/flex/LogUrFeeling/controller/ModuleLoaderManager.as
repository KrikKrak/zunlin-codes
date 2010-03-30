package com.zzl.flex.LogUrFeeling.controller
{
	import com.zzl.flex.LogUrFeeling.Model.MainModelLocator;
	
	import flash.utils.Dictionary;
	
	import mx.events.FlexEvent;
	import mx.events.ModuleEvent;
	import mx.modules.ModuleLoader;
	
	public class ModuleLoaderManager
	{
		private static var _inst:ModuleLoaderManager;
		
		private var _mainModelLocator:MainModelLocator = MainModelLocator.inst;
		private var _modules:Dictionary;
		private var _curLoadingModule:String = "";
		
		static public function get inst():ModuleLoaderManager
		{
			if (_inst == null)
			{
				_inst = new ModuleLoaderManager(new ModuleLoaderManagerConstrctor);
			}
			
			return _inst;
		}
		
		public function ModuleLoaderManager(val:ModuleLoaderManagerConstrctor)
		{
			_modules = new Dictionary;
		}
		
		public function loadModule(url:String):Boolean
		{
			if (_modules[url] != null)
			{
				return false;
			}
			
			var m:ModuleLoader = new ModuleLoader;
			m.addEventListener(ModuleEvent.ERROR, OnModuleLoadError, false, 0, true);
			m.addEventListener(ModuleEvent.PROGRESS, OnModuleLoadProgress, false, 0, true);
			m.addEventListener(ModuleEvent.READY, OnModuleLoadReady, false, 0, true);
			m.addEventListener(FlexEvent.LOADING, OnModuleLoadStartLoad, false, 0, true);
			
			m.url = url;
			_modules[url] = m;
			_curLoadingModule = url;
			return true;
		}
		
		public function getModuleLoader(url:String):ModuleLoader
		{
			if (_modules[url] != null)
			{
				return _modules[url];
			}
			else
			{
				return null;
			}
		}
		
		private function OnModuleLoadError(e:ModuleEvent):void
		{
			trace("OnModuleLoadError");

			var m:ModuleLoader = _modules[_curLoadingModule] as ModuleLoader;
			m.removeEventListener(ModuleEvent.ERROR, OnModuleLoadError);
			m.removeEventListener(ModuleEvent.PROGRESS, OnModuleLoadProgress);
			m.removeEventListener(ModuleEvent.READY, OnModuleLoadReady);
			m.removeEventListener(FlexEvent.LOADING, OnModuleLoadStartLoad);
			delete _modules[_curLoadingModule];
			_curLoadingModule = "";
			
			_mainModelLocator.moduleLoadError = true;
		}
		
		private function OnModuleLoadProgress(e:ModuleEvent):void
		{
			trace("OnModuleLoadProgress", e.bytesLoaded, e.bytesTotal);
			_mainModelLocator.moduleLoadProgress = Math.ceil(e.bytesLoaded / e.bytesTotal);
		}
		
		private function OnModuleLoadReady(e:ModuleEvent):void
		{
			trace("OnModuleLoadReady");
			_curLoadingModule = "";
			_mainModelLocator.moduleLoadReady = true;
		}
		
		private function OnModuleLoadStartLoad(e:FlexEvent):void
		{
			trace("OnModuleLoadStartLoad");
			_mainModelLocator.moduleLoadStart = true;
		}


	}
}

class ModuleLoaderManagerConstrctor
{}