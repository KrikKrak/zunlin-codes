package PEUIComponent.TransformToolSource.RoxioTVCursor
{
	public class RoxioTVMoveCursor extends RoxioTVTransformCursor
	{
		[Bindable]
		[Embed(source="../assets/arrow/05.png")]
		private var moveCursor:Class;
		
		public function RoxioTVMoveCursor():void
		{
			curCursor = moveCursor;
		}
	}
}