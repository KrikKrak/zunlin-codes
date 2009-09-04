package com.zzl.flex.LogUrFeeling.Service
{
	public class SubmitFeelingService extends CommonService
	{
		private var _sURL:String;
		private var _sParam:Object;
		
		public function SubmitFeelingService(url:String, param:Object)
		{
			_sURL = url;
			_sParam = param;
			
			super();
		}
		
		override protected function PostInit():void
		{
			_serviceName = "SubmitFeelingService";
			
			_httpRequest.method = "POST";
			_httpRequest.url = _sURL;
			_httpRequest.request = _sParam;
		}
	}
}