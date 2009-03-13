package com.zzl.flex.familymenu.controller
{
	import caurina.transitions.Tweener;
	
	import com.zzl.flex.familymenu.model.ChartType;
	import com.zzl.flex.familymenu.view.BarChartView;
	import com.zzl.flex.familymenu.view.PieChartView;
	import com.zzl.flex.familymenu.view.StaticDGView;
	
	import mx.collections.ArrayCollection;
	import mx.core.UIComponent;
	
	public class ChartManager
	{
		private static var _inst:ChartManager;
		
		private var _curChartType:String;
		private var _curChart:UIComponent;
		private var _curChartParent:UIComponent;
		private var _curChartData:ArrayCollection;
		
		public static function get inst():ChartManager
		{
			if (_inst == null)
			{
				_inst = new ChartManager(new ChartManagerCreator);
			}
			
			return _inst;
		}
		
		public function ChartManager(val:ChartManagerCreator){}	

		public function createChart(chartParent:UIComponent, chartType:String, chartData:ArrayCollection):void
		{
			switch (chartType)
			{
				case ChartType.BAR:
					CreateBarChart(chartParent, chartData);
					break;
					
				case ChartType.PIE:
					CreatePieChart(chartParent, chartData);
					break;
					
				case ChartType.COLUMN:
					CreateColumnChart(chartParent, chartData);
					break;
					
				case ChartType.DG:
					CreateDataGrid(chartParent, chartData);
					break;				
			}
		}
		
		private function CreatePieChart(chartParent:UIComponent, chartData:ArrayCollection):void
		{
			var oldParent:UIComponent = _curChartParent;
			if (_curChartParent != chartParent)
			{
				_curChartParent = chartParent;
			}
			
			var pc:PieChartView;
			if (_curChartType == ChartType.PIE)
			{
				pc = _curChart as PieChartView;
			}
			else
			{
				pc = new PieChartView;
				var oldChart:UIComponent = _curChart;
				_curChart = pc;
				_curChartType = ChartType.PIE;
				_curChartParent.addChild(pc);
				pc.alpha = 0;
				CrossFadeCharts(pc, oldChart, oldParent, pc.effectDuration * 4 / 1000);
			}
			_curChartData = chartData;
			pc.dataArray = chartData;
		}
		
		private function CreateBarChart(chartParent:UIComponent, chartData:ArrayCollection):void
		{
			var oldParent:UIComponent = _curChartParent;
			if (_curChartParent != chartParent)
			{
				_curChartParent = chartParent;
			}
			
			var bc:BarChartView;
			if (_curChartType == ChartType.BAR)
			{
				bc = _curChart as BarChartView;
			}
			else
			{
				bc = new BarChartView;
				var oldChart:UIComponent = _curChart;
				_curChart = bc;
				_curChartType = ChartType.BAR;
				_curChartParent.addChild(bc);
				bc.alpha = 0;
				CrossFadeCharts(bc, oldChart, oldParent, bc.effectDuration * 4 / 1000);
			}
			_curChartData = chartData;
			bc.dataArray = chartData;
		}
		
		private function CreateColumnChart(chartParent:UIComponent, chartData:ArrayCollection):void
		{
			
		}
		
		private function CreateDataGrid(chartParent:UIComponent, chartData:ArrayCollection):void
		{
			var oldParent:UIComponent = _curChartParent;
			if (_curChartParent != chartParent)
			{
				_curChartParent = chartParent;
			}
			
			var dg:StaticDGView;
			if (_curChartType == ChartType.DG)
			{
				dg = _curChart as StaticDGView;
			}
			else
			{
				dg = new StaticDGView;
				var oldChart:UIComponent = _curChart;
				_curChart = dg;
				_curChartType = ChartType.DG;
				_curChartParent.addChild(dg);
				dg.alpha = 0;
				CrossFadeCharts(dg, oldChart, oldParent, dg.effectDuration * 4 / 1000);
			}
			_curChartData = chartData;
			dg.dataArray = chartData;
		}
		
		private function CrossFadeCharts(inChart:UIComponent, outChart:UIComponent, outChartParent:UIComponent, dur:int):void
		{
			Tweener.addTween(inChart, {alpha: 1, time: dur, transition: "easeOutCubic"});
			Tweener.addTween(outChart, {alpha: 0, time: dur,
										onComplete: RemoveOldChart, onCompleteParams:[outChartParent, outChart]});
		}
		
		private function RemoveOldChart(parent:UIComponent, chart:UIComponent):void
		{
			if (parent.contains(chart))
			{
				parent.removeChild(chart);
				chart = null;
			}
		}
		
	}
}

class ChartManagerCreator{}