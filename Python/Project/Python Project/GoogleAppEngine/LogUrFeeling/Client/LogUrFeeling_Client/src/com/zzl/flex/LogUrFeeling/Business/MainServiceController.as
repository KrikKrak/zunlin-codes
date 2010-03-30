package com.zzl.flex.LogUrFeeling.Business
{
	import com.zzl.flex.LogUrFeeling.Service.CommonService;
	
	public class MainServiceController
	{
		private static var _inst:MainServiceController;

		static public function get inst():MainServiceController
		{
			if (_inst == null)
			{
				_inst = new MainServiceController(new MainServiceControllerConstrctor);
			}
			
			return _inst;
		}
		
		public function MainServiceController(val:MainServiceControllerConstrctor)
		{}
		
		public function getSubmitFeelingService():CommonService
		{
			
		}

	}
}

class MainServiceControllerConstrctor
{}