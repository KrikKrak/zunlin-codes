package com.zzl.flex.familymenu.controller
{
	import com.roxio.online.flexLogger.controller.LogManager;
	import com.roxio.online.flexLogger.controller.Logger;
	import com.zzl.flex.algorithm.GUIDGenerator;
	import com.zzl.flex.familymenu.business.MainServiceLocator;
	import com.zzl.flex.familymenu.model.*;
	import com.zzl.flex.familymenu.model.viewCommand.*;
	import com.zzl.flex.familymenu.view.NewDishView;
	import com.zzl.flex.familymenu.view.SimpleSearchWnd;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	
	public class MainController
	{
		private static var _inst:MainController;
		
		private var _logger:Logger;
		private var _eventCenter:CommonEventCenter = CommonEventCenter.inst;
		private var _mainService:MainServiceLocator = MainServiceLocator.inst;
		private var _modelLocator:GlobeModelLocator = GlobeModelLocator.inst;
		private var _chartManager:ChartManager = ChartManager.inst; 
		
		public static function get inst():MainController
		{
			if (_inst == null)
			{
				_inst = new MainController(new MainControllerCreator);
			}
			
			return _inst;
		}
		
		public function MainController(val:MainControllerCreator){}	
		
		public function initController():void
		{
			_logger = LogManager.inst.getLogger("MainController");
			_eventCenter.initEvents();
		}
		
		public function getDishs():void
		{
			var xmlString:String = _mainService.readDishs();
			if (xmlString == null || xmlString.length == 0)
			{
				_modelLocator.dishs = new ArrayCollection;
			}
			else
			{
				_modelLocator.dishs = GenerateDishsFromXMLString(xmlString);
			}
		}
		
		public function handleCommand(cName:String, cParam:Object = null):void
		{
			switch(cName)
			{
				case CreateNewDishViewCommand.NAME:
					ShowNewDishWnd(GlobeModelLocator.NEW_DISK_VIEW_MODEL_CREATE);
					break;
					
				case NewDishSubmitCommand.NAME:
					if (SaveDish((cParam as NewDishSubmitCommand).dishDetail) == true)
					{
						_logger.fine("handleCommand", "NewDishSubmitCommand, save dish success!");
						HideNewDishWnd((cParam as NewDishSubmitCommand).target as NewDishView);
					}
					else
					{
						_logger.error("handleCommand", "NewDishSubmitCommand, save dish error!");
					}
					break;
					
				case NewDishCancelCommand.NAME:
					HideNewDishWnd((cParam as NewDishCancelCommand).target as NewDishView);
					break;
					
				case DeleteDishCommand.NAME:
					DeleteDish((cParam as DeleteDishCommand).dishID);
					break;
					
				case EditDishCommand.NAME:
					EditDish((cParam as EditDishCommand).dishID);
					break;
				
				case CreateSimpleSearchViewCommand.NAME:
					ShowSimpleSearchWnd(cParam as CreateSimpleSearchViewCommand);
					break;
					
				case SimpleSearchViewCloseCommand.NAME:
					SimpleSearchCloseWnd(cParam as SimpleSearchViewCloseCommand);
					break;
					
				case SearchDishCommand.NAME:
					SearchDish(cParam as SearchDishCommand);
					break;
					
				case CreateChartCommand.NAME:
					CreateChart(cParam as CreateChartCommand);
					break;
			}
		}
		
		public function getDishCategortMap():ArrayCollection
		{
			return DishCategory.categoryMap;
		}
		
		public function getDishTypeMap():ArrayCollection
		{
			return DishType.typeMap;
		}
		
		public function getSeasonStaticData():ArrayCollection
		{
			var sprint:int = 0;
			var summer:int = 0;
			var fall:int = 0;
			var winter:int = 0;
			for each (var dish:DishDetail in _modelLocator.dishs)
			{
				for each (var s:int in dish.suitableSeason)
				{
					switch (s)
					{
						case 1:
							sprint++;
							break;
						case 2:
							summer++;
							break;
						case 3:
							fall++;
							break;
						case 4:
							winter++;
							break;
					}
				}
			}
			var r:ArrayCollection = new ArrayCollection;
			r.addItem({name: GlobeModelLocator.SPRING, value: sprint});
			r.addItem({name: GlobeModelLocator.SUMMER, value: summer});
			r.addItem({name: GlobeModelLocator.FALL, value: fall});
			r.addItem({name: GlobeModelLocator.WINTER, value: winter});
			
			return r;
		}
		
		public function getHotStaticData():ArrayCollection
		{
			var hot:int = 0;
			var notHot:int = 0;
			for each (var dish:DishDetail in _modelLocator.dishs)
			{
				if (dish.isHot)
				{
					hot++;
				}
				else
				{
					notHot++;
				}
			}
			var r:ArrayCollection = new ArrayCollection;
			r.addItem({name: GlobeModelLocator.HOT, value: hot});
			r.addItem({name: GlobeModelLocator.NOTHOT, value: notHot});
			
			return r;
		}
		
		public function getRateStaticData():ArrayCollection
		{
			var staticArray:ArrayCollection = new ArrayCollection;
			for (var i:int = 1; i < 6; ++i)
			{
				staticArray.addItem({name: i.toString() + "星级", value: 0, compareName: i});
			}

			for each (var dish:DishDetail in _modelLocator.dishs)
			{
				for each (var o:Object in staticArray)
				{
					if (dish.rate == o.compareName)
					{
						o.value++;
					}
				}
			}
			
			var r:ArrayCollection = new ArrayCollection;
			for each (o in staticArray)
			{
				if (o.value != 0)
				{
					r.addItem(o);
				}
			}

			return r;
		}
		
		public function getCategoryStaticData():ArrayCollection
		{
			var staticArray:ArrayCollection = new ArrayCollection;
			var ca:ArrayCollection = getDishCategortMap();
			for each (var c:String in ca)
			{
				staticArray.addItem({name: c, value: 0});
			}

			for each (var dish:DishDetail in _modelLocator.dishs)
			{
				for each (var o:Object in staticArray)
				{
					if (dish.category == o.name)
					{
						o.value++;
					}
				}
			}
			
			var r:ArrayCollection = new ArrayCollection;
			for each (o in staticArray)
			{
				if (o.value != 0)
				{
					r.addItem(o);
				}
			}

			return r;
		}
		
		public function getTypeStaticData():ArrayCollection
		{
			var staticArray:ArrayCollection = new ArrayCollection;
			var ca:ArrayCollection = getDishTypeMap();
			for each (var c:String in ca)
			{
				staticArray.addItem({name: c, value: 0});
			}

			for each (var dish:DishDetail in _modelLocator.dishs)
			{
				for each (var o:Object in staticArray)
				{
					if (dish.dishType == o.name)
					{
						o.value++;
					}
				}
			}
			
			var r:ArrayCollection = new ArrayCollection;
			for each (o in staticArray)
			{
				if (o.value != 0)
				{
					r.addItem(o);
				}
			}

			return r;
		}
		
		public function getTopRateStaticData(no:int):ArrayCollection
		{
			var dishs:ArrayCollection = new ArrayCollection;
			for each (var d:DishDetail in _modelLocator.dishs)
			{
				dishs.addItem({id: d.id, name: d.name, value: d.rate, useCount: d.usedTimes});
			}
			
			var sf1:SortField = new SortField("value", false, true);
			sf1.numeric = true;
			var sf2:SortField = new SortField("useCount", false, true);
			sf2.numeric = true;
			var sort:Sort = new Sort;
			sort.fields = [sf1, sf2];
			
			dishs.sort = sort;
			dishs.refresh();
			
			var r:ArrayCollection = new ArrayCollection;
			for (var i:int = 0; i < Math.min(no, dishs.length); ++i)
			{
				r.addItemAt(dishs[i], 0);
			}
			
			return r;			
		}
		
		public function getTopUseStaticData(no:int):ArrayCollection
		{
			var dishs:ArrayCollection = new ArrayCollection;
			for each (var d:DishDetail in _modelLocator.dishs)
			{
				dishs.addItem({id: d.id, name: d.name, value: d.usedTimes});
			}
			
			var sf1:SortField = new SortField("value", false, true);
			sf1.numeric = true;
			var sort:Sort = new Sort;
			sort.fields = [sf1];
			
			dishs.sort = sort;
			dishs.refresh();
			
			var r:ArrayCollection = new ArrayCollection;
			for (var i:int = 0; i < Math.min(no, dishs.length); ++i)
			{
				r.addItemAt(dishs[i], 0);
			}
			
			return r;			
		}
		
		public function getTopRecentAddStaticData(no:int):ArrayCollection
		{
			var dishs:ArrayCollection = new ArrayCollection;
			for each (var d:DishDetail in _modelLocator.dishs)
			{
				dishs.addItem(d);
			}
			
			var sf1:SortField = new SortField("createDate", false, true);
			var sort:Sort = new Sort;
			sort.fields = [sf1];
			
			dishs.sort = sort;
			dishs.refresh();
			
			var r:ArrayCollection = new ArrayCollection;
			for (var i:int = 0; i < Math.min(no, dishs.length); ++i)
			{
				r.addItem(dishs[i]);
			}
			
			return r;			
		}
		
		public function getTopRecentUseStaticData(no:int):ArrayCollection
		{
			var dishs:ArrayCollection = new ArrayCollection;
			for each (var d:DishDetail in _modelLocator.dishs)
			{
				dishs.addItem(d);
			}
			
			var sf1:SortField = new SortField("recentUsedDate", false, true);
			var sort:Sort = new Sort;
			sort.fields = [sf1];
			
			dishs.sort = sort;
			dishs.refresh();
			
			var r:ArrayCollection = new ArrayCollection;
			for (var i:int = 0; i < Math.min(no, dishs.length); ++i)
			{
				r.addItem(dishs[i]);
			}
			
			return r;			
		}
		
		private function CreateChart(p:CreateChartCommand):void
		{
			_chartManager.createChart(p.chartParent, p.chartType, p.chartData);
		}
		
		private function EditDish(id:String):void
		{
			var dishs:ArrayCollection = _modelLocator.dishs;
			for (var i:int = 0; i < dishs.length; ++i)
			{
				if ((dishs[i] as DishDetail).id == id)
				{
					_modelLocator.curDish = dishs[i];
					break;
				}
			}
			ShowNewDishWnd(GlobeModelLocator.NEW_DISK_VIEW_MODEL_MODIFY);
		}
		
		private var _dishID:String;
		private function DeleteDish(id:String):void
		{
			_dishID = id;
			Alert.show("输入一个菜多辛苦啊，真的要删啊？", "", Alert.YES | Alert.NO , null, OnDeleteDishAlertBack);
		}
		
		private function OnDeleteDishAlertBack(e:CloseEvent):void
		{
			if (e.detail == Alert.YES)
			{
				DeleteDishImpl(_dishID);
			}
		}
		
		private function DeleteDishImpl(id:String):void
		{
			var dishs:ArrayCollection = _modelLocator.dishs;
			for (var i:int = 0; i < dishs.length; ++i)
			{
				if ((dishs[i] as DishDetail).id == id)
				{
					dishs.removeItemAt(i);
					break;
				}
			}
			_modelLocator.dishs = dishs;
			_mainService.saveDishs(CreateDishsXMLString(dishs));
		}
		
		private function SaveDish(dish:DishDetail):Boolean
		{
			var id:String = dish.id;
			var dishs:ArrayCollection = _modelLocator.dishs;
			var findDish:DishDetail;
			var findDishIndex:int = -1;
			for (var i:int = 0; i < dishs.length; ++i)
			{
				if ((dishs[i] as DishDetail).id == id)
				{
					findDish = dishs[i] as DishDetail;
					findDishIndex = i;
					break;
				}
			}
			
			if (_modelLocator.newDishViewModel == GlobeModelLocator.NEW_DISK_VIEW_MODEL_CREATE)
			{
				if (findDish != null)
				{
					// dish already exists.
					// NOTE:
					// This case won't happen b/c we search for ID in all dishs. But ID is invisible to user. So user has no way
					// to change a ID for and exists dish.
					// We do this is b/c we allow same NAME for dishs.
					_logger.error("SaveDish", "Find same ID when create new dish!");
					return false;
				}
				else
				{
					dishs.addItem(dish);
				}
			}
			else
			{
				if (findDish == null)
				{
					// something wrong
					_logger.error("SaveDish", "Can not find dish with this ID for editing: " + id);
					return false;
				}
				else
				{
					dishs.addItemAt(dish, findDishIndex);
					dishs.removeItemAt(findDishIndex + 1);
				}
			}
			_modelLocator.dishs = dishs;
			
			return _mainService.saveDishs(CreateDishsXMLString(dishs));
		}
		
		private function CreateDishsXMLString(dishs:ArrayCollection):String
		{
			var xml:XML = <FamilyMenu></FamilyMenu>;
			xml.Version = GlobeModelLocator.VERSION;
			
			var DishsXML:XML = <Dishs></Dishs>;
			for (var i:int = 0; i < dishs.length; ++i)
			{
				DishsXML.appendChild((dishs[i] as DishDetail).toXML());
			}
			xml.appendChild(DishsXML);
			return xml.toXMLString();
		}
		
		private function GenerateDishsFromXMLString(xmlString:String):ArrayCollection
		{
			var xml:XML = new XML(xmlString);
			var dishs:ArrayCollection = new ArrayCollection;
			for each (var dish:XML in xml.Dishs.Dish)
			{
				dishs.addItem(DishDetail.fromXML(dish));
			}
			return dishs;
		}
		
		private function ShowNewDishWnd(showMode:String):void
		{
			if (_modelLocator.isNewDishShowUp == false)
			{
				_modelLocator.newDishViewModel = showMode;
				var newDishWnd:NewDishView = new NewDishView;
				_modelLocator.mainFrame.addChild(newDishWnd);
				_modelLocator.isNewDishShowUp = true;
			}
		}
		
		private function HideNewDishWnd(view:NewDishView):void
		{
			if (_modelLocator.isNewDishShowUp == true && view != null)
			{
				_modelLocator.isNewDishShowUp = false;
				view.close();
				_modelLocator.mainFrame.removeChild(view);
			}
		}
		
		private function ShowSimpleSearchWnd(p:CreateSimpleSearchViewCommand):void
		{
			if (_modelLocator.isSimpleSearchShowUp == false)
			{
				var simpleSearchWnd:SimpleSearchWnd = new SimpleSearchWnd;
				simpleSearchWnd.addListener(p.listenerFn);
				_modelLocator.mainFrame.addChild(simpleSearchWnd);
				_modelLocator.isSimpleSearchShowUp = true;
			}
		}
		
		private function SimpleSearchCloseWnd(p:SimpleSearchViewCloseCommand):void
		{
			if (_modelLocator.isSimpleSearchShowUp == true)
			{
				_modelLocator.isSimpleSearchShowUp = false;
				var view:SimpleSearchWnd = p.target as SimpleSearchWnd;
				view.removeAllListener();
				_modelLocator.mainFrame.removeChild(view);
				view = null;
			}
		}
		
		private function SearchDish(p:SearchDishCommand):void
		{
			var result:ArrayCollection = DoComplexSearch(p.searchRang, p.keywords, p.category, p.type, p.hot, p.season, p.rate);
			p.resultCallbackFunction(result);
		}
		
		private function DoComplexSearch(	dishs:ArrayCollection,
															keywords:ArrayCollection,
															category:ArrayCollection = null,
															type:ArrayCollection = null,
															hot:ArrayCollection = null,
															season:ArrayCollection = null,
															rate:ArrayCollection = null):ArrayCollection
		{
			var result:ArrayCollection = new ArrayCollection;
			
			for (var i:int = 0; i < dishs.length; ++i)
			{
				var dish:DishDetail = dishs[i] as DishDetail;
				
				// search keywords
				var keywordFit:Boolean = false;
				if (keywords.length == 0)
				{
					keywordFit = true;
				}
				else
				{
					for each (var k:String in keywords)
					{
						if (String(dish.name).search(k) != -1)
						{
							keywordFit = true;
							break;
						}
						else
						{
							var contentString:String = dish.content.toArray().join(" ");
							if (contentString.search(k) != -1)
							{
								keywordFit = true;
								break;
							}
						}
					}
				}
				
				if (keywordFit == false)
				{
					continue;
				}
				
				// search category
				if (category != null)
				{
					var categoryFit:Boolean = false;
					for each (var c:String in category)
					{
						if (c == dish.category)
						{
							categoryFit = true;
							break;
						}
					}
					
					if (categoryFit == false)
					{
						continue;
					}
				}
				
				// search type
				if (type != null)
				{
					var typeFit:Boolean = false;
					for each (var t:String in type)
					{
						if (t == dish.dishType)
						{
							typeFit = true;
							break;
						}
					}
					
					if (typeFit == false)
					{
						continue;
					}
				}
				
				// search hot
				if (hot != null)
				{
					var hotFit:Boolean = false;
					for each (var h:Boolean in hot)
					{
						if (h == dish.isHot)
						{
							hotFit = true;
							break;
						}
					}
					
					if (hotFit == false)
					{
						continue;
					}
				}
				
				// search season
				if (season != null)
				{
					var seasonFit:Boolean = false;
					for each (var s:int in season)
					{
						for each (var ts:int in dish.suitableSeason)
						{
							if (s == ts)
							{
								seasonFit = true;
								break;
							}
						}
						if (seasonFit == true)
						{
							break;
						}
					}
					
					if (seasonFit == false)
					{
						continue;
					}
				}

				// search rate
				if (rate != null)
				{
					var rateFit:Boolean = false;
					for each (var r:int in rate)
					{
						if (r == dish.rate)
						{
							rateFit = true;
							break;
						}
					}
					
					if (rateFit == false)
					{
						continue;
					}
				}
				
				result.addItem(dish);
			}

			return result;
		}
		
		
		//------------------------------------------------------------------
		// test functions
		public function createFakeDishs(n:int):ArrayCollection
		{
			var dishs:ArrayCollection = new ArrayCollection;
			var cMap:ArrayCollection = DishCategory.categoryMap;
			var cMapLength:int = cMap.length;
			var dMap:ArrayCollection = DishType.typeMap;
			var dMapLength:int = dMap.length;
			
			for (var i:int = 0; i < n; ++i)
			{
				var dish:DishDetail = new DishDetail;
				dish.id = GUIDGenerator.getGUID();
				dish.name = "Fake dish " + i.toString();
				dish.isHot = (Math.random() > 0.5);
				dish.category = String(cMap.getItemAt(Math.round(Math.random() * (cMapLength - 1))));
				dish.rate = Math.round(Math.random() * 4) + 1;
				dish.dishType = String(dMap.getItemAt(Math.round(Math.random() * (dMapLength - 1))));
				dish.usedTimes = Math.round(Math.random() * 20);
				dish.notes = dish.name + "; GUID: " + dish.id;
				
				var s:int = Math.round(Math.random() * 3) + 1;
				for (var j:int = 0; j < s; ++j)
				{
					dish.suitableSeason.addItem(Math.round(Math.random() * 3) + 1);
				}
				
				dishs.addItem(dish);
			}
			
			var l:int = dishs.length;
			for each (dish in dishs)
			{
				var m:int = Math.round(Math.random() * 10);
				for (var k:int = 0; k < m; ++k)
				{
					var d:DishDetail = dishs.getItemAt(Math.round(Math.random() * (l - 1))) as DishDetail;
					dish.combineWith.addItem({id: d.id, name: d.name});
				}
			}
			
			return dishs;
		}
		
		public function createFakeData(n:int):void
		{
			var dishs:ArrayCollection = createFakeDishs(n);
			_mainService.saveDishs(CreateDishsXMLString(dishs));
		}

	}
}

class MainControllerCreator{}