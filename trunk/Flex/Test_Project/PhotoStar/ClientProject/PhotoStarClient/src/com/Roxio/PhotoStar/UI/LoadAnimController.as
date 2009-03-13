package com.Roxio.PhotoStar.UI
{
	import com.Roxio.PhotoStar.Mode.GlobeSetting;
	import com.Roxio.PhotoStar.Mode.IAnimDisplayObject;
	
	import mx.collections.ArrayCollection;
	
	public class LoadAnimController
	{
		private var _objectArray:ArrayCollection;
		private var _loadCallBackFn:Function;
		
		private var _runningObjectCount:int = 0;
		private var _hideCallBackFn:Function;
		
		public function LoadAnimController(loadCallBackFn:Function = null)
		{
			super();
			
			_loadCallBackFn = loadCallBackFn;
			_objectArray = new ArrayCollection;
		}
		
		public function addDisplayObject(obj:IAnimDisplayObject):void
		{
			_objectArray.addItem(obj);
		}
		
		public function loadObjects():void
		{
			if (_objectArray.length > 0)
			{
				GlobeSetting.loadAnimRunning = true;
				var dispObj:IAnimDisplayObject = _objectArray[0] as IAnimDisplayObject;
				_objectArray.removeItemAt(0);
				dispObj.startLoad(loadObjects);
			} 
			else
			{
				GlobeSetting.loadAnimRunning = false;
				if (_loadCallBackFn != null)
				{
					_loadCallBackFn();
				}
			}
		}
		
		public function changeObject(hideObj:IAnimDisplayObject, showObj:IAnimDisplayObject, hideCallBackFn:Function = null):void
		{
			GlobeSetting.loadAnimRunning = true;
			_hideCallBackFn = hideCallBackFn;
			if (hideObj != null)
			{
				_runningObjectCount = 2;
				hideObj.startHide(ObjectChangeEnd);
			}
			else
			{
				_runningObjectCount = 1;
			}
			showObj.startLoad(ObjectChangeEnd);
		}
		
		private function ObjectChangeEnd():void
		{
			--_runningObjectCount;
			if (_runningObjectCount == 0)
			{
				GlobeSetting.loadAnimRunning = false;
				if (_hideCallBackFn != null)
				{
					_hideCallBackFn();
				}
			}
		}
	}
}