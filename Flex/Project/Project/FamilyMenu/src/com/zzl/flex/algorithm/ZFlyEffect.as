package com.zzl.flex.algorithm
{
	import caurina.transitions.Tweener;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import mx.core.Container;
	import mx.core.UIComponent;
	
	public class ZFlyEffect
	{
		private var _target:UIComponent;
		private var _targetParent:Container;
		private var _dir_out:Boolean = true;
		private var _duration:int = 1000;
		private var _callbackFunction:Function = null;
		private var _callbackFnParam:Object = null;
		
		private var _targetBitmapData:BitmapData;
		private var _targetBitmap:Bitmap;
		private var _contentReady:Boolean = false;
		
		public function ZFlyEffect(target:UIComponent, tParent:Container,
												dir_out:Boolean = true, dur:int = 1000,
												cbFn:Function = null, fnParam:Object = null)
		{
			_contentReady = false;
			
			_target = target;
			_targetParent = tParent;
			_duration = dur;
			_dir_out = dir_out;
			_callbackFunction = cbFn;
			_callbackFnParam = fnParam;
			
			PrepareContent();
		}
		
		/*
		public function play():void
		{
			if (_contentReady == false)
			{
				PrepareContent();
			}
			
			
			_targetParent.rawChildren.addChild(_targetBitmap);
			_targetBitmap.x = _target.x;
			_targetBitmap.y = _target.y;
			_targetBitmap.width = _target.width;
			_targetBitmap.height = _target.height;
			
			var zNu:int = 0;
			var aNu:int = 0;
			if (_dir_out == true)
			{
				_targetBitmap.alpha = 1;
				_targetBitmap.z = 0;
				
				zNu = -100;
				aNu = 0;
			}
			else
			{
				_targetBitmap.alpha = 1;
				_targetBitmap.z = 1000;
				
				zNu = 0;
				aNu = 1;
			}
			
			Tweener.addTween(_targetBitmap, {z: zNu, alpha: aNu, time: _duration / 1000,
										transition: "easeOutCubic",
										onComplete: OnFlyEffectEnd});
										
			_target.alpha = 0;
		}
		*/
		
		public function play():void
		{
			if (_contentReady == false)
			{
				PrepareContent();
			}
			
			_targetParent.rawChildren.addChild(_targetBitmap);
			_targetBitmap.x = _target.x;
			_targetBitmap.y = _target.y;
			_targetBitmap.width = _target.width;
			_targetBitmap.height = _target.height;
			
			var zNu:int = 0;
			var aNu:int = 0;
			if (_dir_out == true)
			{
				_targetBitmap.x = _target.x;
				_targetBitmap.y = _target.y;
				_targetBitmap.width = _target.width;
				_targetBitmap.height = _target.height;
				_targetBitmap.alpha = 1;
				
				var tWidth:int = 1.5 * _targetBitmap.width;
				var tHeight:int = 1.5 * _targetBitmap.height;

				Tweener.addTween(_targetBitmap, {x: (_targetBitmap.width - tWidth) / 2,
																y: (_targetBitmap.height - tHeight) / 2,
																width: tWidth, height: tHeight,
																alpha: 0, time: _duration / 1000,
																transition: "easeOutCubic",
																onComplete: OnFlyEffectEnd});
			}
			else
			{
				_targetBitmap.width = _target.width * 0.5;
				_targetBitmap.height = _target.height * 0.5;
				_targetBitmap.x = (_target.width - _targetBitmap.width) / 2;
				_targetBitmap.y = (_target.height - _targetBitmap.height) / 2;
				_targetBitmap.alpha = 1;

				Tweener.addTween(_targetBitmap, {x: _target.x,
																y: _target.y,
																width: _target.width, height: _target.height,
																alpha: 1, time: _duration / 1000,
																transition: "easeOutCubic",
																onComplete: OnFlyEffectEnd});
			}

			_target.alpha = 0;
		}
		
		private function OnFlyEffectEnd():void
		{
			_target.alpha = 1;
			_targetParent.rawChildren.removeChild(_targetBitmap);
			DisposeContent();
			_contentReady = false;
			
			if (_callbackFunction != null)
			{
				_callbackFunction(_callbackFnParam);
			}
		}
		
		private function PrepareContent():void
		{
			if (_targetBitmapData != null)
			{
				DisposeContent();
			}
			
			_targetBitmapData = new BitmapData(_target.width, _target.height, true, 0x00FFFFFF);
			_targetBitmapData.draw(_target);
			_targetBitmap = new Bitmap(_targetBitmapData);
			
			_contentReady = true;
		}
		
		private function DisposeContent():void
		{
			_targetBitmapData.dispose();
			_targetBitmapData = null;
			_targetBitmap = null;
		}

	}
}