package com.zzl.flex.familymenu.view.visualizeComponent
{
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import mx.collections.ArrayCollection;
	import mx.core.UIComponent;

	public class Playground extends UIComponent
	{
		protected var _balls:ArrayCollection;
		protected var _playgroundWidth:int = 0;
		protected var _playgroundHeight:int = 0;
		
		protected var _isPlaying:Boolean = false;
		protected var _startTime:int = 0;
		protected var _lastBallEnterTime:int = 0;
		
		protected const BALL_COME_IN_DURATION:int = 2000;	// 2 second for all balls fall down
		protected const GRAVITY:Number = 1;
		protected const BOUNCY:Number = -0.7;
		protected const FRICTION:Number = 1;
		
		public function Playground(w:int, h:int)
		{
			super();
			
			_playgroundWidth = w;
			_playgroundHeight = h;
			InitBalls();
			
			this.addEventListener(Event.ENTER_FRAME, OnEnterFrame, false, 0, true);
		}
		
		protected function InitBalls():void
		{
			_balls = new ArrayCollection;
			for (var i:int = 0; i < 100; ++i)
			{
				var b:BasicBall = new BasicBall(Math.random() * 10 + 10, Math.random() * 0xFFFFFF);
				b.initParam(Math.random() * _playgroundWidth, -b.ballSize * 2, Math.random() * BALL_COME_IN_DURATION);
				b.initPhysics(GRAVITY, FRICTION, BOUNCY);
				_balls.addItem(b);

				this.addChild(b);
				_lastBallEnterTime = Math.max(_lastBallEnterTime, b.delyTime);
			}
			
			// incase the last ball can not be activated, we just make the last ball time a little later
			_lastBallEnterTime += 100;
		}
		
		public function startPlay():void
		{
			_isPlaying = true;
			_startTime = getTimer();
		}
		
		protected function OnEnterFrame(e:Event):void
		{
			if (_isPlaying == true)
			{
				var curPlayTime:int = getTimer() - _startTime;
				if (curPlayTime <= _lastBallEnterTime)
				{
					FallBalls(curPlayTime);
				}
				else
				{
					MoveBalls();
				}
			}
		}
		
		protected function FallBalls(curPlayTime:int):void
		{
			for each (var b:BasicBall in _balls)
			{
				if (b.delyTime <= curPlayTime)
				{
					MoveBall(b);
				}
			}
		}
		
		protected function MoveBalls():void
		{
			for each (var b:BasicBall in _balls)
			{
				MoveBall(b);
			}
		}
		
		protected function MoveBall(b:BasicBall):void
		{
			b.vx += b.ax;
			b.vy += b.ay;
			b.vy += b.gravity;
			b.vx *= b.friction;
			b.vy *= b.friction;
			b.x += b.vx;
			b.y += b.vy;
			
			CheckBorder(b);
		}
		
		protected function CheckBorder(b:BasicBall):void
		{
			if (b.x + b.ballSize / 2 >= _playgroundWidth)
			{
				b.x = _playgroundWidth - b.ballSize / 2;
				b.vx *= b.bouncy;
			}
			if (b.y + b.ballSize / 2 >= _playgroundHeight)
			{
				b.y = _playgroundHeight - b.ballSize / 2;
				b.vy *= b.bouncy;
			}
		}
		
	}
}