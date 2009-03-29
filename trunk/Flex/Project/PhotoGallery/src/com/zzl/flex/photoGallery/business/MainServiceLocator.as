package com.zzl.flex.photoGallery.business
{
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	
	public class MainServiceLocator
	{
		private static var _inst:MainServiceLocator;
		
		private var _pathResolveCallbackFn:Function;
		
		public static function get inst():MainServiceLocator
		{
			if (_inst == null)
			{
				_inst = new MainServiceLocator(new MainServiceLocatorCreator);
			}
			
			return _inst;
		}
		
		public function MainServiceLocator(val:MainServiceLocatorCreator){}
		
		public function resolveRssPaths(cb:Function):void
		{
			_pathResolveCallbackFn = cb;
		}
		
		public function resolveLocalFolderPaths(cb:Function):void
		{
			_pathResolveCallbackFn = cb;
		}
		
		public function resolveTestFolderPaths(cb:Function):void
		{
			_pathResolveCallbackFn = cb;
			var a:ArrayCollection = new ArrayCollection;
			var dPath:String = File.documentsDirectory.nativePath;
			for (var i:int = 1; i < 2; ++i)
			{
				a.addItem("file:///" + dPath + "\\PhotoGalleryTestData\\a" + i.toString() + ".jpg");
			}
			
			if (_pathResolveCallbackFn != null)
			{
				_pathResolveCallbackFn(a);
			}
			return;
		}

	}
}

class MainServiceLocatorCreator{}