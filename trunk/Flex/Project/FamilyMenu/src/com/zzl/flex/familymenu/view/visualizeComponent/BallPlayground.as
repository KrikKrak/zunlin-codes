package com.zzl.flex.familymenu.view.visualizeComponent
{
	import com.zzl.flex.familymenu.model.DishDetail;
	import com.zzl.flex.familymenu.model.customEvent.VisualDataTargetPickEvent;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	public class BallPlayground extends Playground
	{
		private var _dishs:ArrayCollection;
		private var _oldTarget:DishBall;
		private var _curTarget:DishBall;
		
		private const EASING_VALUE:Number = 0.2;
		
		public function BallPlayground(w:int, h:int, dishs:ArrayCollection = null)
		{
			_dishs = dishs;
			super(w, h);
		}
		
		override protected function InitBalls():void
		{
			_balls = new ArrayCollection;
			
			if (_dishs == null)
			{
				return;
			}
			
			for each (var dish:DishDetail in _dishs)
			{
				var b:DishBall = new DishBall(dish.rate * 5 + 10, Math.random() * 0xFFFFFF);
				b.initParam(Math.random() * _playgroundWidth, -b.ballSize * 2, Math.random() * BALL_COME_IN_DURATION);
				b.initPhysics(GRAVITY, FRICTION, BOUNCY);
				b.addEventListener(VisualDataTargetPickEvent.E_VISUAL_DATA_TARGET_PICK, OnTargetDishBallPick, false, 0, true);
				_balls.addItem(b);

				this.addChild(b);
				_lastBallEnterTime = Math.max(_lastBallEnterTime, b.delyTime);
			}
			
			// incase the last ball can not be activated, we just make the last ball time a little later
			_lastBallEnterTime += 100;
		}
		
		private function OnTargetDishBallPick(e:Event):void
		{
			if (e.target is DishBall)
			{
				_oldTarget = _curTarget;
				if (_oldTarget != null)
				{
					_oldTarget.gravity = GRAVITY;
					_oldTarget.vy = 0;
					_oldTarget.releaseTarget();
				}
				
				_curTarget = e.target as DishBall;
				_curTarget.gravity = 0;
				_curTarget.vy = -10;
				_curTarget.activeTarget();
			}
		}
		
		override protected function OnEnterFrame(e:Event):void
		{
			super.OnEnterFrame(e);
			
			if (_curTarget != null)
			{
				EaseMove();
			}
		}
		
		private function EaseMove():void
		{
			var vy:Number = (_playgroundHeight / 2 - _curTarget.y) * EASING_VALUE;
			_curTarget.y += vy;
		}
	}
}