package com.zzl.flex.familymenu.view.visualizeComponent
{
	import flash.display.Graphics;
	
	import mx.core.UIComponent;

	public class BasicBall extends UIComponent
	{
		protected var g:Graphics;
		protected var _size:Number = 1;
		protected var _color:uint = 0xFF8000;
		
		protected var _initX:int = 0;
		protected var _initY:int = 0;
		protected var _animStartDelyTime:int = 0;
		
		protected var _gravity:Number = 0;
		protected var _friction:Number = 0;
		protected var _bouncy:Number = 0;
		
		protected var _vx:Number = 0;
		protected var _vy:Number = 0;
		protected var _ax:Number = 0;
		protected var _ay:Number = 0;
		
		public function BasicBall(size:Number, color:uint)
		{
			super();
			
			g = this.graphics;
			_size = size;
			_color = color;
			
			DrawSelf();
		}
		
		public function set vx(val:Number):void
		{
			_vx = val;
		}
		
		public function get vx():Number
		{
			return _vx;
		}
		
		public function set vy(val:Number):void
		{
			_vy = val;
		}
		
		public function get vy():Number
		{
			return _vy;
		}
		
		public function set ax(val:Number):void
		{
			_ax = val;
		}
		
		public function get ax():Number
		{
			return _ax;
		}
		
		public function set ay(val:Number):void
		{
			_ay = val;
		}
		
		public function get ay():Number
		{
			return _ay;
		}
		
		public function set gravity(val:Number):void
		{
			_gravity = val;
		}
		
		public function get gravity():Number
		{
			return _gravity;
		}
		
		public function set friction(val:Number):void
		{
			_friction = val;
		}
		
		public function get friction():Number
		{
			return _friction;
		}
		
		public function set bouncy(val:Number):void
		{
			_bouncy = val;
		}
		
		public function get bouncy():Number
		{
			return _bouncy;
		}
		
		public function get ballSize():Number
		{
			return _size;
		}
		
		public function get ballColor():uint
		{
			return _color
		}
		
		public function get delyTime():int
		{
			return _animStartDelyTime;
		}
		
		public function initParam(ix:int, iy:int, dt:int):void
		{
			_initX = ix;
			_initY = iy;
			_animStartDelyTime = dt;
			
			this.x = _initX;
			this.y = _initY;
		}
		
		public function initPhysics(g:Number, f:Number, b:Number):void
		{
			_gravity = g;
			_friction = f;
			_bouncy = b;
		}

		protected function DrawSelf():void
		{
			g.beginFill(_color);
			g.drawCircle(0, 0, _size / 2);
			g.endFill();
		}
		
	}
}