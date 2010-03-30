package com.Roxio.PhotoStar.Algorithm
{
	public class BaseAction
	{
		protected var _actionName:String;
		protected var _data:Object;
		protected var _param:Object;
		
		public function set data(val:Object):void
		{
			_data = val;
		}
		
		public function set param(val:Object):void
		{
			_param = val;
		}
		
		public function get param():Object
		{
			return _param;
		}
		
		public function execute():Boolean
		{
			return true;
		}
		
		public function undo():Boolean
		{
			return true;
		}
		
		public function redo():Boolean
		{
			return true;
		}
		
		public function get actionName():String
		{
			return _actionName;
		}
		
		public function toActionXML():XML
		{
			return null;
		}
	}
}