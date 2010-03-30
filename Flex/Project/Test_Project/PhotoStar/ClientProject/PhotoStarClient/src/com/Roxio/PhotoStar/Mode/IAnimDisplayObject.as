package com.Roxio.PhotoStar.Mode
{
	public interface IAnimDisplayObject
	{
		function startLoad(loadEndCallBackFn:Function):Boolean;
		function startHide(hideEndCallBackFn:Function):Boolean;
	}
}