package com.zzl.flex.familymenu.view.visualizeComponent
{
	import com.zzl.flex.familymenu.model.DishDetail;
	import com.zzl.flex.familymenu.model.customEvent.VisualDataTargetPickEvent;
	
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	public class BallPlayground extends Playground
	{
		private var _dishs:ArrayCollection;
		private var _oldTargets:ArrayCollection;
		private var _mainTarget:DishBall;
		private var _minorTargets:ArrayCollection;
		private var _ballMap:Dictionary;
		private var _g:Graphics;
		
		private const EASING_VALUE:Number = 0.2;
		
		public function BallPlayground(w:int, h:int, dishs:ArrayCollection = null)
		{
			_dishs = dishs;
			
			_oldTargets = new ArrayCollection;
			_minorTargets = new ArrayCollection;
			_ballMap = new Dictionary();
			_g = this.graphics;
			
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
				var b:DishBall = new DishBall(dish.rate * 5 + 10, Math.random() * 0xFFFFFF, dish);
				b.initParam(Math.random() * _playgroundWidth, -b.ballSize * 2, Math.random() * BALL_COME_IN_DURATION);
				b.initPhysics(GRAVITY, FRICTION, BOUNCY);
				b.addEventListener(VisualDataTargetPickEvent.E_VISUAL_DATA_TARGET_PICK, OnDishBallClick, false, 0, true);
				_balls.addItem(b);
				
				// create id-ball map
				_ballMap[dish.id] = b;
				
				// add to screen
				this.addChild(b);
				_lastBallEnterTime = Math.max(_lastBallEnterTime, b.delyTime);
			}
			
			// incase the last ball can not be activated, we just make the last ball time a little later
			_lastBallEnterTime += 100;
		}
		
		private function OnDishBallClick(e:Event):void
		{
			if (e.target is DishBall)
			{
				var curBall:DishBall = e.target as DishBall;
				if (curBall != _mainTarget)
				{
					if (_mainTarget != null)
					{
						_oldTargets.addItem(_mainTarget);
						for each (var b:DishBall in _minorTargets)
						{
							if (b != curBall)
							{
								_oldTargets.addItem(b);
							}
						}
						_minorTargets.removeAll();
					}
					_mainTarget = curBall;
					InitNewTarget();
				}
				else if (_minorTargets.length == 0)
				{
					for each (var obj:Object in _mainTarget.dish.combineWith)
					{
						var cd:DishBall = _ballMap[obj.id] as DishBall;
						if (cd != _mainTarget && cd != null)
						{
							_minorTargets.addItem(_ballMap[obj.id]);
						}
					}
					InitMinorTargets();
				}
			}
		}
		
		private function InitNewTarget():void
		{
			DeactiveOldTargets();
			
			_mainTarget.gravity = 0;
			_mainTarget.activeTarget(true);
		}
		
		private function InitMinorTargets():void
		{
			if (_minorTargets.length != 0)
			{
				for each (var b:DishBall in _minorTargets)
				{
					b.gravity = 0;
					b.activeTarget(false);
				}
			}
		}
		
		private function DeactiveOldTargets():void
		{
			if (_oldTargets != null && _oldTargets.length > 0)
			{
				for each (var b:DishBall in _oldTargets)
				{
					b.gravity = GRAVITY;
					b.vy = 0;
					b.releaseTarget();
				}
				_oldTargets.removeAll();
				_g.clear();
			}
		}
		
		override protected function OnEnterFrame(e:Event):void
		{
			super.OnEnterFrame(e);
			
			if (_minorTargets.length != 0)
			{
				MoveMinorTargets();
			}
		}
		
		override protected function MoveBalls():void
		{
			for each (var b:DishBall in _balls)
			{
				if (b == _mainTarget)
				{
					MoveMainTarget();
				}
				else if (_minorTargets.getItemIndex(b) == -1)
				{
					MoveBall(b);
				}
			}
		}
		
		private function MoveMainTarget():void
		{
			var vy:Number = (_playgroundHeight / 2 - _mainTarget.y) * EASING_VALUE;
			_mainTarget.y += vy;
		}
		
		private function MoveMinorTargets():void
		{
			_g.clear();
			_g.lineStyle(1, 0xFFFFFF);
			for each (var b:DishBall in _minorTargets)
			{
				var vy:Number = (_playgroundHeight * 3 / 4 - b.y) * EASING_VALUE;
				b.y += vy;
				_g.moveTo(b.x, b.y);
				_g.lineTo(_mainTarget.x, _mainTarget.y);
			}
		}
	}
}