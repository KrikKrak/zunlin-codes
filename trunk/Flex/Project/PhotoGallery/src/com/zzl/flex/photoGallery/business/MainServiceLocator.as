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
		
		public function resolveLocalFolderPaths(paths:ArrayCollection, cb:Function):void
		{
			_pathResolveCallbackFn = cb;
			var a:ArrayCollection = new ArrayCollection;
			for each (var folder:String in paths)
			{
				var dir:File = new File(folder);
				var lists:Array = dir.getDirectoryListing();
				for each (var f:File in lists)
				{
					if (f.isDirectory == false && IsImage(f.extension) == true)
					{
						a.addItem(f.nativePath);
					}
				}
			}
			
			if (_pathResolveCallbackFn != null)
			{
				_pathResolveCallbackFn(a);
			}
			return;
		}
		
		public function resolveTestFolderPaths(cb:Function):void
		{
			_pathResolveCallbackFn = cb;
			var a:ArrayCollection = new ArrayCollection;
			var dPath:String = File.documentsDirectory.nativePath;
			for (var i:int = 1; i < 12; ++i)
			{
				a.addItem("file:///" + dPath + "\\PhotoGalleryTestData\\a" + i.toString() + ".jpg");
			}
			
			if (_pathResolveCallbackFn != null)
			{
				_pathResolveCallbackFn(a);
			}
			return;
		}
		
		private function IsImage(s:String):Boolean
		{
			switch (s.toLowerCase())
			{
				case "jpg":
					return true;
				
				case "jpeg":
					return true;
				
				case "png":
					return true;
					
				case "gif":
					return true;
			}
			return false;
		}

	}
}

class MainServiceLocatorCreator{}