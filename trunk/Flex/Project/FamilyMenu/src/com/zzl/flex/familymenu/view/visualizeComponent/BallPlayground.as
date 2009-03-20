package com.zzl.flex.familymenu.view.visualizeComponent
{
	import com.zzl.flex.familymenu.model.DishDetail;
	import com.zzl.flex.familymenu.model.customEvent.VisualDataTargetMouseEvent;
	
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
		private var _dishInfoPanel:DishBallDetailPanel;
		
		private var _mainTargetInPosition:Boolean = false;
		private var _minorTargetsInPosition:Boolean = false;
		private var _isTargetDraging:Boolean = false;

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
				b.addEventListener(VisualDataTargetMouseEvent.E_VISUAL_DATA_TARGET_MOUSE_CLICK, OnDishBallClick, false, 0, true);
				b.addEventListener(VisualDataTargetMouseEvent.E_VISUAL_DATA_TARGET_MOUSE_OUT, OnDishBallMouseOut, false, 0, true);
				b.addEventListener(VisualDataTargetMouseEvent.E_VISUAL_DATA_TARGET_MOUSE_OVER, OnDishBallMouseOver, false, 0, true);
				b.addEventListener(VisualDataTargetMouseEvent.E_VISUAL_DATA_TARGET_MOUSE_START_DRAG, OnDishBallMouseStartDrag, false, 0, true);
				b.addEventListener(VisualDataTargetMouseEvent.E_VISUAL_DATA_TARGET_MOUSE_END_DRAG, OnDishBallMouseEndDrag, false, 0, true);
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
		
		private function OnDishBallMouseOut(e:Event):void
		{
			if (_dishInfoPanel != null)
			{
				_dishInfoPanel.visible = false;
			}
		}
		
		private function OnDishBallMouseOver(e:Event):void
		{
			trace(_isTargetDraging);
			if (e.target is DishBall && _isTargetDraging == false)
			{
				if (_dishInfoPanel == null)
				{
					_dishInfoPanel = new DishBallDetailPanel;
					this.addChild(_dishInfoPanel);
				}
				
				var d:DishBall = e.target as DishBall;
				var xo:Number = PositionInfoPanel(d);
				_dishInfoPanel.updateDishInfo(d.dish.name, d.dish.rate, d.dish.usedTimes, xo);
			}
		}
		
		private function OnDishBallMouseStartDrag(e:Event):void
		{
			if (e.target is DishBall)
			{
				_dishInfoPanel.visible = false;				
				_isTargetDraging = true;
			}
		}
		
		private function OnDishBallMouseEndDrag(e:Event):void
		{
			_isTargetDraging = false;
		}
		
		private function PositionInfoPanel(b:DishBall):Number
		{
			_dishInfoPanel.visible = true;
			_dishInfoPanel.x = b.x - _dishInfoPanel.width / 2;
			_dishInfoPanel.y = b.y - _dishInfoPanel.height - b.ballSize;
			
			if (_dishInfoPanel.x < 0)
			{
				_dishInfoPanel.x = 0
			}
			else if (_dishInfoPanel.x + _dishInfoPanel.width > this.width)
			{
				_dishInfoPanel.x = this.width - _dishInfoPanel.width;
			}
			
			return b.x - _dishInfoPanel.x;
		}

		private function OnDishBallClick(e:Event):void
		{
			if (e.target is DishBall)
			{
				var curBall:DishBall = e.target as DishBall;
				if (curBall != _mainTarget)
				{
					// setup main target
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

					// setup minor target (combieWith dishs)
					for each (var obj:Object in _mainTarget.dish.combineWith)
					{
						var cd:DishBall = _ballMap[obj.id] as DishBall;
						if (cd != _mainTarget && cd != null)
						{
							_minorTargets.addItem(_ballMap[obj.id]);
						}
					}

					InitNewTarget();
				}
			}
		}

		private function InitNewTarget():void
		{
			_mainTargetInPosition = false;
			_minorTargetsInPosition = false;
			
			DeactiveOldTargets();

			_mainTarget.gravity = 0;
			_mainTarget.activeTarget(true);

			InitMinorTargets();
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
			if (_mainTargetInPosition == false)
			{
				var vy:Number = (_playgroundHeight / 3 - _mainTarget.y) * EASING_VALUE;
				_mainTarget.y += vy;
				
				if (Math.abs(_mainTarget.y - _playgroundHeight / 3) < 0.1)
				{
					_mainTargetInPosition = true;
				}
			}
		}

		private function MoveMinorTargets():void
		{
			if (_minorTargetsInPosition == false)
			{
				_minorTargetsInPosition = true;
				for each (var b:DishBall in _minorTargets)
				{
					var vy:Number = (_playgroundHeight * 2 / 3 - b.y) * EASING_VALUE;
					b.y += vy;
					
					if (Math.abs(b.y - _playgroundHeight * 2 / 3) > 0.1)
					{
						_minorTargetsInPosition = false;
					}
				}
			}
			
			_g.clear();
			_g.lineStyle(1, 0xFFFFFF);
			for each (b in _minorTargets)
			{
				_g.moveTo(b.x, b.y);
				_g.lineTo(_mainTarget.x, _mainTarget.y);
			}
		}
	}
}