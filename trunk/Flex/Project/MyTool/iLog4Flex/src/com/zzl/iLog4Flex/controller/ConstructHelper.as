package com.zzl.iLog4Flex.controller
{
	/**
	 * ConstructHelper
	 * @author zunlin_zhang
	 * @date 9/3/2008
	 * 
	 * This class is used for new a Logger instence. We don't want user new the Logger by themselves,
	 * the only way to new it is by using LogManager.getLogger. So we put a param in Logger's construct.
	 * We send this class as a param to the construct so it can only be created within the packet.
	 */	
	
	internal class ConstructHelper
	{
		public function ConstructHelper()
		{
		}
	}
}