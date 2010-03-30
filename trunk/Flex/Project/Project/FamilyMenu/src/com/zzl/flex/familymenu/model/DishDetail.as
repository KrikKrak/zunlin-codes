package com.zzl.flex.familymenu.model
{
	import com.zzl.flex.algorithm.CommonTools;
	
	import mx.collections.ArrayCollection;
	
	public class DishDetail
	{
		// A GUID for each dish
		public var id:String = "";
		// Chinese name of the dish
		public var name:String = "";
		// Indicate which season is suitable for this dish
		public var suitableSeason:ArrayCollection = new ArrayCollection;
		// hot or not
		public var isHot:Boolean = false;
		// Which category the dish belongs to
		public var category:String = DishCategory.OTHER;
		// Any other dishs that can be eaten whit this dish
		// the element should be Object{id: "SOME-GUID", name: "DISH-NAME"}
		public var combineWith:ArrayCollection = new ArrayCollection;
		// How popular this dish is
		public var rate:int = 0;
		// Which dish type is
		public var dishType:String = DishType.OTHER;
		// How many times the dish is used
		public var usedTimes:int = 1;
		// Create date
		public var createDate:Date = new Date;
		// Recent used date
		public var recentUsedDate:Date = new Date;
		// Content for making this dish
		public var content:ArrayCollection = new ArrayCollection;
		// Other notes
		public var notes:String = "";
		
		public function isSameDish(otherDish:DishDetail):Boolean
		{
			if (id != otherDish.id)
			{
				return false;
			}
			if (name != otherDish.name)
			{
				return false;
			}
			if (isHot != otherDish.isHot)
			{
				return false;
			}
			if (category != otherDish.category)
			{
				return false;
			}
			if (rate != otherDish.rate)
			{
				return false;
			}
			if (dishType != otherDish.dishType)
			{
				return false;
			}
			if (usedTimes != otherDish.usedTimes)
			{
				return false;
			}
			if (!CommonTools.isSameDate(createDate, otherDish.createDate))
			{
				return false;
			}
			if (!CommonTools.isSameDate(recentUsedDate, otherDish.recentUsedDate))
			{
				return false;
			}
			if (!CommonTools.isSameSimpleArrayCollectionContent(suitableSeason, otherDish.suitableSeason))
			{
				return false;
			}
			
			if (combineWith.length != otherDish.combineWith.length)
			{
				return false;
			}
			var c1:Array = new Array;
			for each (var v:Object in combineWith)
			{
				c1.push(v.id);
			}
			var c2:Array = new Array;
			for each (v in otherDish.combineWith)
			{
				c2.push(v.id);
			}
			if (!CommonTools.isSameSimpleArrayContent(c1, c2))
			{
				return false;
			}
			
			if (!CommonTools.isSameSimpleArrayCollectionContent(content, otherDish.content))
			{
				return false;
			}
			if (notes != otherDish.notes)
			{
				return false;
			}
			
			return true;
		}
		
		public function toXML():XML
		{
			var xml:XML = <Dish></Dish>;
			// add basic info
			xml.id = id;
			xml.DishName = CommonTools.encodeXMLSafeString(name);
			xml.IsHot = isHot;
			xml.Rate = rate;
			xml.Category = category;
			xml.DishType = dishType;
			xml.UsedTimes = usedTimes;
			xml.CreateDate = createDate.toString();
			xml.RecentUsedDate = recentUsedDate.toString();
			xml.OtherNotes = CommonTools.encodeXMLSafeString(notes);
			// add suitableSeason
			var Seasons:XML = <Seasons></Seasons>
			for (var i:int = 0; i < suitableSeason.length; ++i)
			{
				var m:XML = <Season>{suitableSeason[i].toString()}</Season>;
				Seasons.appendChild(m);
			}
			xml.appendChild(Seasons);
			// add combineWith
			var CombineWith:XML = <CombineWith></CombineWith>
			for (i = 0; i < combineWith.length; ++i)
			{
				var c:XML =	<OtherDish>
										<Name>{combineWith[i].name}</Name>
										<id>{combineWith[i].id}</id>
									</OtherDish>;
				CombineWith.appendChild(c);
			}
			xml.appendChild(CombineWith);
			// add content
			var Contents:XML = <Contents></Contents>
			for (i = 0; i < content.length; ++i)
			{
				var cc:XML = <Content>{CommonTools.encodeXMLSafeString(content[i])}</Content>;
				Contents.appendChild(cc);
			}
			xml.appendChild(Contents);
			
			return xml;
		}
		
		public static function fromXML(xml:XML):DishDetail
		{
			var dish:DishDetail = new DishDetail;
			dish.id = xml.id.text();
			dish.name = CommonTools.decodeXMLSafeString(xml.DishName.text());
			dish.isHot = (String(xml.IsHot.text()).toLowerCase() == "true") ? true : false;
			dish.rate = int(xml.Rate.text());
			dish.category = xml.Category.text();
			dish.dishType = xml.DishType.text();
			dish.usedTimes = int(xml.UsedTimes.text());
			dish.createDate = new Date(Date.parse(xml.CreateDate.text()));
			dish.recentUsedDate = new Date(Date.parse(xml.RecentUsedDate.text()));
			dish.notes = CommonTools.decodeXMLSafeString(xml.OtherNotes.text());
			
			var m:ArrayCollection = new ArrayCollection;
			for each (var x:XML in xml.Seasons.Season)
			{
				m.addItem(int(x.toString()));
			}
			dish.suitableSeason = m;
			
			var c:ArrayCollection = new ArrayCollection;
			for each (x in xml.CombineWith.OtherDish)
			{
				c.addItem({id: x.id.toString(), name: x.Name.toString()});
			}
			dish.combineWith = c;
			
			var cc:ArrayCollection = new ArrayCollection;
			for each (x in xml.Contents.Content)
			{
				cc.addItem(CommonTools.decodeXMLSafeString(x.toString()));
			}
			dish.content = cc;
				
			return dish;
		}
	}
}