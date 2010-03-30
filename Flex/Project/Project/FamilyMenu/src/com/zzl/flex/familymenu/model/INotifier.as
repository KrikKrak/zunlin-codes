package com.zzl.flex.familymenu.model
{
	public interface INotifier
	{
		function addListener(fn:Function):Boolean;
		function removeListener(fn:Function):Boolean;
		function removeAllListener():void;
		function notifyListener(param:Object):void;
	}
}