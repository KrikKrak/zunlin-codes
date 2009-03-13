package com.zzl.flex.familymenu.view
{
	import com.zzl.flex.algorithm.ZFlyEffect;
	
	import flash.display.DisplayObject;
	
	import mx.containers.ViewStack;
	import mx.core.Container;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;

	public class AnimatedViewStack extends ViewStack
	{
		private var _effectDuration:int = 500;	// ms
		private var _oldTarget:Container;
		private var _childCreateCompleteListener:Object = {};
		private var _scheduleAnimation:Boolean = true;
			
		public function AnimatedViewStack()
		{
			super();
		}

		override public function addChild(child:DisplayObject):DisplayObject
		{
			if (child is Container)
			{
				(child as Container).addEventListener(FlexEvent.CREATION_COMPLETE, OnChildCreateComplete, false, 0, true);
				_childCreateCompleteListener[child.toString()] = false;
			}
			return super.addChild(child);
		}
		
		private function OnChildCreateComplete(e:FlexEvent):void
		{
			if (_childCreateCompleteListener[e.target.toString()] != null)
			{
				_childCreateCompleteListener[e.target.toString()] = true;
				(e.target as UIComponent).removeEventListener(FlexEvent.CREATION_COMPLETE, OnChildCreateComplete);
				
				if (_scheduleAnimation == true)
				{
					_scheduleAnimation = false;
					AnimateChildren();
				}
			}
		}
			
		override protected function commitSelectedIndex(newIndex:int):void
		{
			super.commitSelectedIndex(newIndex);

			if (_childCreateCompleteListener[this.selectedChild.toString()] == true)
			{
				AnimateChildren();
			}
			else
			{
				// we need the old target still be visible untile the new target is loaded complete
				if (_oldTarget != null)
				{
					_oldTarget.visible = true;
				}
				_scheduleAnimation = true;
			}
		}

		private function AnimateChildren():void
		{
			if (this.selectedChild != _oldTarget)
			{
				if (_oldTarget != null)
				{
					var o_zfe:ZFlyEffect = new ZFlyEffect(_oldTarget, this.parent as Container, true, _effectDuration, OnOldTargetOut);
					o_zfe.play();
				}
				
				var n_zfe:ZFlyEffect = new ZFlyEffect(this.selectedChild, this.parent as Container, false, _effectDuration, OnNewTargetIn);
				n_zfe.play()
			}
		}
		
		private function OnOldTargetOut(p:Object = null):void
		{
			_oldTarget.visible = false;
		}
		
		private function OnNewTargetIn(p:Object = null):void
		{
			_oldTarget = this.selectedChild;
		}
	}
}