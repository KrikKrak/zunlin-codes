package PEUIComponent
{
	import ASCode.BitmapHolder;
	import ASCode.Filter.ColorMask;
	import ASCode.PhotoEditBitmap;
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.managers.CursorManager;
	
	public class ColorMaskPanel extends DragPanel
	{
		public static const PEN:int = 0;
		public static const ERASER:int = 1;
		
		private static var inst:ColorMaskPanel = null;
		
		private const MAX_PEN_SIZE:int = 200;
		private const MIN_PEN_SIZE:int = 4;
		private const PEN_SIZE_INTERVAL:int = 2;
		
		[Bindable]
		[Embed(source="../assets/transBackground.png")]
		private var transCursor:Class;
		private var cursorID:int;
		
		private var _maskColor:uint = 0x000000;
		private var _maskSize:int = 20;
		private var _curScale:Number = 1.0;
		private var _mode:int = PEN;
		private var _isDrawing:Boolean = false;
		private var _mouseCenter:Point;
		
		private var _data:PhotoEditBitmap;
		private var _filterData:BitmapHolder;
		private var _filter:ColorMask;
		
		public function ColorMaskPanel()
		{
			super();
			
			_mouseCenter = new Point(0, 0);
			
			this.addEventListener(MouseEvent.ROLL_OVER, OnMouseOver, false, 0, true);
			this.addEventListener(MouseEvent.ROLL_OUT, OnMouseOut, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_MOVE, OnMouseMove, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_DOWN, OnMouseDown, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_UP, OnMouseUp, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_WHEEL, OnMouseWheel, false, 0, true);
		}
	
		public static function GetColorMaskPanel():ColorMaskPanel
		{
			if (inst == null)
			{
				inst = new ColorMaskPanel;
			}
			return inst;
		}
		
		public function set maskColor(val:uint):void
		{
			_maskColor = val;
		}
		
		public function set maskSize(val:int):void
		{
			_maskSize = val;
			_maskSize = Math.min(Math.max(_maskSize, MIN_PEN_SIZE), MAX_PEN_SIZE);
			UpdateMouseCursor();
		}
		
		public function set bitmapData(data:PhotoEditBitmap):void
		{
			_data = data;
			CreateFilterData();
		}
		
		public function set mode(val:int):void
		{
			_mode = val;
		}
		
		public function dataSizeChange(scale:Number):void
		{
			_curScale = scale;
			if (_data != null)
			{
				var rect:Rectangle = _data.dataGlobalRect;
				this.x = 0;
				this.y = 0;
				var lStartPos:Point = this.globalToLocal(new Point(rect.x, rect.y));
				this.x = lStartPos.x;
				this.y = lStartPos.y;
				this.width = rect.width;
				this.height = rect.height;
				
				UpdateDataSize();
			}
		}
		
		public function whitenDone():void
		{
			trace("whitenDone");
			_filter.mergeMask(_data.bitmapData);
			_filterData.releaseData();
		}
		
		override public function IsMouseOver(mx:Number, my:Number):Boolean
		{
			return true;
		}
		
		override public function get moveable():Boolean
		{
			return false;
		}
		
		override public function CanDrag(mx:Number, my:Number):Boolean
		{
			return false;
		}
		
		override public function ChangDragPos(xOffset:Number, yOffset:Number):void
		{
			return;
		}
		
		private function OnMouseOver(event:MouseEvent):void
		{
			cursorID = CursorManager.setCursor(transCursor);
		}
		
		private function OnMouseOut(event:MouseEvent):void
		{
			_isDrawing = false;
			
			CursorManager.removeCursor(cursorID)
			graphics.clear();
		}
		
		private function OnMouseMove(event:MouseEvent):void
		{
			UpdateMouseCursor();
			
			if (_isDrawing == true && _filter != null)
			{
				if (_mode == PEN)
				{
					_filter.drawCircle(Screen2ActuralSize(_mouseCenter.x), Screen2ActuralSize(_mouseCenter.y), Screen2ActuralSize(_maskSize));
				}
				else
				{
					_filter.eraseRect(Screen2ActuralSize(_mouseCenter.x - _maskSize), Screen2ActuralSize(_mouseCenter.y - _maskSize), Screen2ActuralSize(_maskSize * 2), Screen2ActuralSize(_maskSize * 2));
					//_filter.eraseCircle(Screen2ActuralSize(_mouseCenter.x), Screen2ActuralSize(_mouseCenter.y), Screen2ActuralSize(_maskSize));
				}
			}
		}
		
		private function OnMouseDown(event:MouseEvent):void
		{
			UpdateMouseCursor();
			
			_isDrawing = true;
			
			if (_filter != null)
			{
				if (_mode == PEN)
				{
					_filter.drawCircle(Screen2ActuralSize(_mouseCenter.x), Screen2ActuralSize(_mouseCenter.y), Screen2ActuralSize(_maskSize));
				}
				else
				{
					_filter.eraseRect(Screen2ActuralSize(_mouseCenter.x - _maskSize), Screen2ActuralSize(_mouseCenter.y - _maskSize), Screen2ActuralSize(_maskSize * 2), Screen2ActuralSize(_maskSize * 2));
					//_filter.eraseCircle(Screen2ActuralSize(_mouseCenter.x), Screen2ActuralSize(_mouseCenter.y), Screen2ActuralSize(_maskSize));
				}
			}
		}
		
		private function OnMouseUp(event:MouseEvent):void
		{
			_isDrawing = false;
		}
		
		private function OnMouseWheel(event:MouseEvent):void
		{
			_maskSize += -event.delta * PEN_SIZE_INTERVAL;
			_maskSize = Math.min(Math.max(_maskSize, MIN_PEN_SIZE), MAX_PEN_SIZE);
			UpdateMouseCursor();
		}
		
		private function UpdateMouseCursor():void
		{
			_mouseCenter.x = Math.min(this.width - _maskSize, Math.max(_maskSize, this.mouseX));
			_mouseCenter.y = Math.min(this.height - _maskSize, Math.max(_maskSize, this.mouseY))
			
			var g:Graphics = this.graphics;
			g.clear();
			
			g.lineStyle(1, 0xff8000);
			if (_mode == PEN)
			{
				g.drawCircle(_mouseCenter.x, _mouseCenter.y, _maskSize);
			}
			else
			{
				g.drawRect(_mouseCenter.x - _maskSize, _mouseCenter.y - _maskSize, _maskSize * 2, _maskSize * 2);
			}
		}
		
		private function CreateFilterData():void
		{
			if (_data == null)
			{
				return;
			}
			
			if (_filterData != null && this.contains(_filterData))
			{
				this.removeChild(_filterData);
				_filterData = null;
			}
			
			// create a new bitmapdata with the pic's size and transparent background for color fill
			var data:BitmapData = new BitmapData(_data.bitmapData.width, _data.bitmapData.height, true, 0x00ffffff);
			_filterData = new BitmapHolder(null, data);
			this.addChild(_filterData);
			
			CreateFilter(data);
		}
		
		private function CreateFilter(data:BitmapData):void
		{
			_filter = new ColorMask(data);
			_filter.maskColor = _maskColor;
		}
		
		private function UpdateDataSize():void
		{
			if (_filterData != null)
			{
				_filterData.x = 0;
				_filterData.y = 0;
				_filterData.width = this.width;
				_filterData.height = this.height;
			}
		}
		
		private function Screen2ActuralSize(val:Number):Number
		{
			return (100 * val / _curScale);
		}
	}
}