package PEUIComponent.TransformToolSource.RoxioTVCursor
{
	public class RoxioTVScaleCursor extends RoxioTVTransformCursor
	{
		[Bindable]
		[Embed(source="../assets/arrow/04.png")]
		private var scaleCursor:Class;
		
		public function RoxioTVScaleCursor():void
		{
			curCursor = scaleCursor;
		}
	}
}