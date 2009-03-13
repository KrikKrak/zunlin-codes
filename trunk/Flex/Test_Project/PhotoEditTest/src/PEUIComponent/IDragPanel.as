package PEUIComponent
{
	public interface IDragPanel
	{
		function IsMouseOver(mx:Number, my:Number):Boolean;
		function CanDrag(mx:Number, my:Number):Boolean;
		function ChangDragPos(xOffset:Number, yOffset:Number):void;
		function get moveable():Boolean;
	}
}