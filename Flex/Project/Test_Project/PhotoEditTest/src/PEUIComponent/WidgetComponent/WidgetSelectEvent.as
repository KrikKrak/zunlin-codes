package PEUIComponent.WidgetComponent
{
	import flash.display.DisplayObject;
	import flash.events.Event;

	public class WidgetSelectEvent extends Event
	{
		public static const WIDGET_SELECT:String = "widget_select";
		
		public var widget:DisplayObject;
		public var widgetSource:Object;
		public var widgetOwner:DisplayObject;
		public var widgetID:int = 0;
		
		public function WidgetSelectEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}