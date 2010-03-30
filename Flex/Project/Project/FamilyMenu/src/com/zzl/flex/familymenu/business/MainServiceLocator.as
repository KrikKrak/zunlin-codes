package com.zzl.flex.familymenu.business
{
	import flash.filesystem.*;
	
	public class MainServiceLocator
	{
		private static var _inst:MainServiceLocator;
		private static const LOCAL_FILE_NAME:String = "FamilyMenu.xml";
		
		public static function get inst():MainServiceLocator
		{
			if (_inst == null)
			{
				_inst = new MainServiceLocator(new MainServiceLocatorCreator);
			}
			
			return _inst;
		}
		
		public function MainServiceLocator(val:MainServiceLocatorCreator){}
		
		public function saveDishs(s:String):Boolean
		{
			if (s.length == 0)
			{
				return false;
			}
			
			var file:File = File.documentsDirectory.resolvePath(LOCAL_FILE_NAME);
			var fs:FileStream = new FileStream;
			fs.open(file, FileMode.WRITE);
			fs.writeUTFBytes(s);
			return true;
		}
		
		public function readDishs():String
		{
			var file:File = File.documentsDirectory.resolvePath(LOCAL_FILE_NAME);
			if (file.exists == false)
			{
				return "";
			}
			
			var fs:FileStream = new FileStream;
			fs.open(file, FileMode.READ);
			
			var xmlString:String = fs.readUTFBytes(fs.bytesAvailable);
			return xmlString;
		}

	}
}

class MainServiceLocatorCreator{}