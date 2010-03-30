package com.Roxio.OnlineObject
{
	import flash.display.DisplayObject;
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	import flash.utils.Timer;
	
	public class BreathGlowBorder
	{
		private static var inst:BreathGlowBorder = null
		private const BREATH_INTERVAL:int = 80;
		
		private var objectArray:Array;
		private var borderSizeArray:Array;
		private var breathIntervalTimer:Timer;
		
				
		public static function SetNewObject(obj:DisplayObject, filter:GlowFilter):void
		{
			var ins:BreathGlowBorder = GetInst();
			ins.SetObject(obj, filter);
		}
		
		public static function RemoveObject(obj:DisplayObject):void
		{
			var ins:BreathGlowBorder = GetInst();
			ins.RemoveObject(obj);
		}
		
		private static function GetInst():BreathGlowBorder
		{
			if (inst == null)
			{
				inst = new BreathGlowBorder;
				inst.CreateBorderSizeArray();
			}
			return inst;
		}
		
		// Construct function
		public function BreathGlowBorder():void
		{
			objectArray = new Array;
			borderSizeArray = new Array;
			
			breathIntervalTimer = new Timer(BREATH_INTERVAL);
			breathIntervalTimer.addEventListener(TimerEvent.TIMER, OnBreathInterval, false, 0, true);
			breathIntervalTimer.stop();
		}
		
		public function SetObject(obj:DisplayObject, filter:GlowFilter):void
		{
			if (FindObject(obj) == -1)
			{
				// The objPair array contains two elements, one is the display object, another is the relating filter.
				var objPair:Array = new Array;
				objPair.push(obj);
				filter.quality = borderSizeArray[borderSizeArray[0]];
				objPair.push(filter);
				objectArray.push(objPair);
				
				if (breathIntervalTimer.running == false)
				{
					breathIntervalTimer.start();
				}
			}
		}
		
		public function RemoveObject(obj:DisplayObject):void
		{
			var index:int = FindObject(obj); 
			if (index != -1)
			{
				objectArray.splice(index, 1);
				
				if (objectArray.length == 0)
				{
					breathIntervalTimer.stop();
				}
			}
		}
		
		private function FindObject(obj:DisplayObject):int
		{
			for (var i:int = 0; i < objectArray.length; ++i)
			{
				var objPair:Array = objectArray[i] as Array;
				if (obj == objPair[0] as DisplayObject)
				{
					return i;
				}
			}
			return -1;
		}
		
		private function CreateBorderSizeArray():void
		{
			borderSizeArray.splice(0, borderSizeArray.length);
			
			// the first element of borderSizeArray is the index of current border size
			borderSizeArray.push(1);
			
			// create the array from small to large then to small again
			var stepNumber:int = 20;
			var maxNumber:int = 15;
			var minNumber:int = 3;
			var interval:Number = (maxNumber - minNumber) / stepNumber;
			
			for (var i:int = 0; i < stepNumber; ++i)
			{
				borderSizeArray.push(minNumber + i * interval);
			}
			for (i = 0; i < stepNumber; ++i)
			{
				borderSizeArray.push(maxNumber - i * interval);
			}
		}
		
		private function OnBreathInterval(event:TimerEvent):void
		{
			UpdateBorder();
		}
		
		private function UpdateBorder():void
		{
			if (borderSizeArray[0] == borderSizeArray.length - 1)
			{
				borderSizeArray[0] = 1;
			}
			else
			{
				borderSizeArray[0] += 1;
			}
			
			for (var i:int = 0; i < objectArray.length; ++i)
			{
				var objPair:Array = objectArray[i] as Array;
				(objPair[1] as GlowFilter).blurX = borderSizeArray[borderSizeArray[0]];
				(objPair[1] as GlowFilter).blurY = borderSizeArray[borderSizeArray[0]];
				(objPair[0] as DisplayObject).filters = [(objPair[1] as GlowFilter)];
			}
		}
	}
}