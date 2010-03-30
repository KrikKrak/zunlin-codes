package PEUIComponent.TransformToolSource.RoxioTVCursor
{
	public class RoxioTVRotateCursor extends RoxioTVTransformCursor
	{
		[Bindable]
		[Embed(source="../assets/arrow/06.png")]
		private var rotateCursor:Class;
		
		public function RoxioTVRotateCursor():void
		{
			curCursor = rotateCursor;
		}
	}
}