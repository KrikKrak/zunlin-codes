package com.zzl.flex.algorithm
{
	import mx.collections.ArrayCollection;
	
	public class CommonTools
	{
		public static function isSameSimpleArrayContent(a1:Array, a2:Array):Boolean
		{
			if (a1.length != a2.length)
			{
				return false;
			}
			
			var a:Array = new Array;
			for each (var v:Object in a1)
			{
				a.push(v);
			}
			
			var b:Array = new Array;
			for each (v in a2)
			{
				b.push(v);
			}
			
			a.sort();
			b.sort();
			for (var i:int = 0; i < a.length; ++i)
			{
				if (a[i] != b[i])
				{
					return false;
				}
			}
			
			return true;
		}
		
		public static function isSameSimpleArrayCollectionContent(a1:ArrayCollection, a2:ArrayCollection):Boolean
		{
			if ((a1 == null && a2 != null) || (a1 != null && a2 == null))
			{
				return false;
			}
			else if (a1 == null && a2 == null)
			{
				return true;
			}
			else
			{
				return isSameSimpleArrayContent(a1.toArray(), a2.toArray());
			}
		}
		
		public static function copySimpleArrayCollection(target:ArrayCollection, source:ArrayCollection):void
		{
			if (source == null)
			{
				return;
			}
			
			if (target == null)
			{
				target = new ArrayCollection;
			}
			else
			{
				target.removeAll();
			}
			
			for each (var item:Object in source)
			{
				target.addItem(item);
			}
		}
		
		public static function trimString(s:String):String
		{
			var s1:String = trimHeadString(s);
			var s2:String = trimTailString(s1);
			return s2;
		}
		
		public static function trimHeadString(s:String):String
		{
			if (s.length == 0)
			{
				return s;
			}
			
			var firstWordIndex:int = -1;
			for (var i:int = 0; i < s.length; ++i)
			{
				var b:String = s.charAt(i);
				if (b == " " || b == "　")
				{
					continue;
				}

				firstWordIndex = i;
				break;
			}
			
			if (firstWordIndex != -1)
			{
				var s1:String = s.substr(firstWordIndex, s.length - firstWordIndex);
				return s1;
			}
			else
			{
				return "";
			}
		}
		
		public static function trimTailString(s:String):String
		{
			if (s.length == 0)
			{
				return s;
			}
			
			var lastWordIndex:int = -1;
			for (var i:int = s.length - 1; i >= 0; --i)
			{
				var b:String = s.charAt(i);
				if (b == " " || b == "　")
				{
					continue;
				}

				lastWordIndex = i;
				break;
			}
			
			if (lastWordIndex != -1)
			{
				var s1:String = s.substring(0, lastWordIndex + 1);
				return s1;
			}
			else
			{
				return "";
			}
		}
		
		public static function isSameDate(d1:Date, d2:Date):Boolean
		{
			if (d1.getFullYear() != d2.getFullYear())
			{
				return false;
			}
			if (d1.getMonth() != d2.getMonth())
			{
				return false;
			}
			if (d1.getDay() != d2.getDay())
			{
				return false;
			}
			return true;
		}
		
		// TODO: add function implementation
		private static const XML_SAFE_STRING_PART1:String = "<![CDATA[";
		private static const XML_SAFE_STRING_PART2:String = "]]>";
		public static function encodeXMLSafeString(val:String):String
		{
			return XML_SAFE_STRING_PART1 + val + XML_SAFE_STRING_PART2;
		}
		
		public static function decodeXMLSafeString(val:String):String
		{
			if (val.substr(0, XML_SAFE_STRING_PART1.length) == XML_SAFE_STRING_PART1)
			{
				val = val.substr(XML_SAFE_STRING_PART1.length, val.length - XML_SAFE_STRING_PART1.length - XML_SAFE_STRING_PART2.length);
				return val;
			}
			else
			{
				return val;
			}
		}
		
		public static function getArrayBySpace(val:String):ArrayCollection
		{
			var r:ArrayCollection = new ArrayCollection;
			var a:Array = val.split(" ");
			for (var i:int = 0; i < a.length; ++i)
			{
				var b:Array = String(a[i]).split("　");	// chinese space
				for (var j:int = 0; j < b.length; ++j)
				{
					if (r.getItemIndex(b[j]) == -1)
					{
						r.addItem(b[j]);
					}
				}
			}
			return r;
		}
		
		public static function grayValueAdjust(c:uint, v:Number):uint
		{
			v = Math.max(0, Math.min(v, 1));
			return ((int(getRValue(c) * v) << 16) + (int(getGValue(c) * v) << 8) + int(getBValue(c) * v));
		}
		
		public static function getAValue(color:uint):uint
		{
			return (color >> 24 & 0xFF);
		}
		
		public static function getRValue(color:uint):uint
		{
			return (color >> 16 & 0xFF);
		}
		
		public static function getGValue(color:uint):uint
		{
			return (color >> 8 & 0xFF);
		}
		
		public static function getBValue(color:uint):uint
		{
			return (color & 0xFF);
		}
		
		public static function mergeARGB(a:uint, r:uint, g:uint, b:uint):uint
		{
			return ((a << 24) + (r << 16) + (g << 8) + b);
		}
		
		public static function mergeRGB(r:uint, g:uint, b:uint):uint
		{
			return ((0xFF << 24) + (r << 16) + (g << 8) + b);
		}
	}
}