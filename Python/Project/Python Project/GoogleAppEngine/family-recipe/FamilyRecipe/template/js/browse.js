/**
 * @author Larry
 */

$(document).ready (function(){
	
	/* put page init function here */
	//alert("page load...");
	
	$("#btnTest").click (function()
	{
		$("#d_name").text("abc");
	})
	
	// hook up listener for filter
	$("#ip_show_all").click (function()
	{
		if ($(this)[0].checked == true)
		{
			$("#cb_type").attr("disabled", "true");
			$("#cb_season").attr("disabled", "true");
			$("#cb_rate").attr("disabled", "true");
		}
		else
		{
			$("#cb_type").removeAttr("disabled");
			$("#cb_season").removeAttr("disabled");
			$("#cb_rate").removeAttr("disabled");
		}
		updateDishs();	
	})
	
	$("#cb_type").change (function()
	{
		updateDishs();
	})
	
	$("#cb_season").change (function()
	{
		updateDishs();
	})
	
	$("#cb_rate").change (function()
	{
		updateDishs();
	})
	
	// var define
	var dishXML;
	var curIdx = 0;
	var recipeCount = 0;
	var dishData = [];
	var result_table_head_str = "<tr><th width='200' scope='col'>菜名</th><th width='80' scope='col'>类别</th><th width='80' scope='col'>种类</th><th width='160' scope='col'>级别</th><th width='80' scope='col'>使用次数</th></tr>";
	
	// disable all select options
	$("#cb_type").attr("disabled", "true");
	$("#cb_season").attr("disabled", "true");
	$("#cb_rate").attr("disabled", "true");
	
	// load xml file
	loadXMLFile();

	// work function
	function loadXMLFile()
	{
		$.ajax({
			type: "GET",
			url: "resource/source.xml",
			dataType: "xml",
			data: "",
			success: xmlLoaded
		})
	}
	
	function xmlLoaded(data)
	{
		dishXML = data;
		dishData = $(dishXML).find("Dish");
		// get xml version first
		var recipeXMLVersion = $(data).find("Version").text();

		// add talbe head
		$("#result_table").append(result_table_head_str);
			
		// get dishs
		var k = 0;
		$(dishXML).find("Dish").each(function(i){
			var dishName = $(this).children("DishName");
			var dnTxt = formatString(dishName.text());
			var category = $(this).children("Category");
			var dishType = $(this).children("DishType");
			var rate = $(this).children("Rate");
			var usedTimes = $(this).children("UsedTimes");
			
			var t = "<tr><td>" + dnTxt + "</td><td>"
								+ category.text() + "</td><td>"
								+ dishType.text() + "</td><td>"
								+ rate.text() + "</td><td>"
								+ usedTimes.text() + "</td></tr>";
								
			$("#result_table").append(t);
			
			k += 1;
		});
		recipeCount = k;
		//alert(recipeCount)
		
		// format table to make it a little nicer
		$("#result_table tr:odd").css("background-color", "#CCCCCC");
		
		// add table row click listener
		$("#result_table tr").click(dishClick);
		
		//addRecipe();
	}
	
	
	function addRecipe()
	{
		if (curIdx < recipeCount)
		{
			var d = "";
			
			var dish = $(dishXML).find("Dish").eq(curIdx);
			//alert(dish)
			var dishName = $(dish).children("DishName");
			var dnTxt = formatString(dishName.text());
			d += "ip_name=" + dnTxt;
			
			var rate = $(dish).children("Rate").text();
			d += "&ip_r=" + rate;
			
			var category = $(dish).children("Category").text();
			d += "&ip_category=" + category;
			
			var dishType = $(dish).children("DishType").text();
			d += "&ip_type=" + dishType;
			
			var usedTimes = $(dish).children("UsedTimes").text();
			//alert(usedTimes)
			d += "&ip_count=" + usedTimes;
			
			var isHot = $(dish).children("IsHot").text();
			if (isHot == "true")
			{
				d += "&ip_hot=" + isHot;
			}
			
			var otherNote = $(dish).children("OtherNotes").text();
			otherNote = formatString(otherNote);
			if (otherNote != "") {
				d += "&ip_other=" + otherNote;
			}
			
			var s = "";
			dish.find("Season").each(function(i){
				var m = formatString($(this).text());
				if (m == "1")
				{
					if (s != "")
					{
						s += "&";
					}
					s += "ip_sprint=true";
				}
				if (m == "2")
				{
					if (s != "")
					{
						s += "&";
					}
					s += "ip_summer=true";
				}
				if (m == "3")
				{
					if (s != "")
					{
						s += "&";
					}
					s += "ip_fall=true";
				}
				if (m == "4")
				{
					if (s != "")
					{
						s += "&";
					}
					s += "ip_winter=true";
				}
			})
			if (s != "") {
				d += "&" + s;
			}

			var c = combineArray(dish, "Content");
			if (c != "") {
				d += "&ip_source=" + c;
			}
			
			var n = combineArray(dish, "Name");
			if (n != "") {
				d += "&ip_combine=" + n;
			}
			
			//alert(d);

			call4Add(d);
		}
	}
	
	function call4Add(d)
	{
		$.ajax({
			type: "POST",
			url: "/postnew",
			data: d,
			success: recipeAdded
		})
	}
	
	function recipeAdded(data)
	{
		curIdx += 1;
		addRecipe();
	}
	
	function updateDishs()
	{
		// find related dishs
		var d;
		if ($("#ip_show_all")[0].checked == true)
		{
			d = $(dishXML).find("Dish");
		}
		else
		{
			d = chooseDishs($("#cb_type")[0].value, $("#cb_season")[0].value, $("#cb_rate")[0].value);
			//alert("Filter dish by " + $("#cb_type")[0].value + ", " + $("#cb_season")[0].value + ", " + $("#cb_rate")[0].value + ", result: " + d.length);
		}
		
		// update dishs to table
		$("#result_table tr").remove();
		
		// add talbe head
		$("#result_table").append(result_table_head_str);
			
		// add dishs
		for (var i = 0; i < d.length; ++i)
		{
			var dishName = $(d[i]).children("DishName");
			var dnTxt = formatString(dishName.text());
			var category = $(d[i]).children("Category");
			var dishType = $(d[i]).children("DishType");
			var rate = $(d[i]).children("Rate");
			var usedTimes = $(d[i]).children("UsedTimes");
			
			var t = "<tr><td>" + dnTxt + "</td><td>"
								+ category.text() + "</td><td>"
								+ dishType.text() + "</td><td>"
								+ rate.text() + "</td><td>"
								+ usedTimes.text() + "</td></tr>";
								
			$("#result_table").append(t);
		}
		
		// format table to make it a little nicer
		$("#result_table tr:odd").css("background-color", "#CCCCCC");
		
		// add table row click listener
		$("#result_table tr").click(dishClick);
	}
	
	function chooseDishs(type, season, rate)
	{
		var d = [];
		$(dishXML).find("Dish").each(function(i){
			var category = $(this).children("Category");
			var ratevalue = $(this).children("Rate");
			
			// get season inside the Dish tag
			var sArray = [];
			$(this).find("Season").each(function(i){
				sArray.push($(this).text());
			})
			
			var typeok = true;
			if (type != "all")
			{
				typeok = (category.text() == type);
			}
			
			var seasonok = true;
			if (season != "all")
			{
				seasonok = false;
				for (var i = 0; i < sArray.length; ++i)
				{
					if (sArray[i] == season)
					{
						seasonok = true;
						break;
					}
				}
			}
			
			var rateok = true;
			if (rate != "all")
			{
				rateok = (ratevalue.text() == rate);
			}
			
			if (typeok == true && seasonok == true && rateok == true)
			{
				d.push(this);
			}
		});
		return d;
	}
	
	function dishClick(e)
	{
		e.stopPropagation();
		var t = e.currentTarget;
		if (t.rowIndex == 0) return;
		
		// find selected dish from xml
		var dish = $(dishXML).find("Dish").eq(t.rowIndex - 1);
		var dishName = $(dish).children("DishName");
		var dnTxt = formatString(dishName.text());
		var rate = $(dish).children("Rate").text();
		var category = $(dish).children("Category").text();
		var dishType = $(dish).children("DishType").text();
		var usedTimes = $(dish).children("UsedTimes").text();
		var isHot = $(dish).children("IsHot").text();
		var otherNote = $(dish).children("OtherNotes").text();
		otherNote = formatString(otherNote);
		var s = combineArray(dish, "Season", getSeason);
		var c = combineArray(dish, "Content");
		var n = combineArray(dish, "Name");

		$("#d_name").text(dnTxt);
		$("#d_category").text(category);
		$("#d_type").text(dishType);
		$("#d_hot").text((isHot == "true") ? "是" : "否");
		$("#d_count").text(usedTimes);
		$("#d_month").text(s);
		$("#d_combine").text(n);
		$("#d_rate").text(rate);
		$("#d_source").text(c);
		$("#d_other").text(otherNote);
		
		openDishDetail();
	}
	
	function removeExistingContents()
	{
		$("#result_table").remove();
	}
	
	function openDishDetail()
	{
		$("#dish_detail_panel").removeClass("hidePanel");
		$("#dish_detail_panel").bind("dialogbeforeclose", beforeDishClose);
		$("#dish_detail_panel").dialog({autoOpen: false, resizable: false, width: 620});
		$("#dish_detail_panel").dialog("option", "modal", true);
		$("#dish_detail_panel").dialog("open");
	}
	
	function beforeDishClose(event, ui)
	{
		// TODO: update dish detail
	}
	
	// ======================================
	// [HELP FUNCTION]
	
	// this function is used to remove "<![[CDATA]]>"
	function formatString(str)
	{
		if (str[0] == "<" && str[5] == "A")
		{
			var s = "";
			for (var i = 9; i < str.length - 3; ++i)
			{
				s += str[i];
			}
			return s;
		}
		else
		{
			return str;
		}
	}
	
	function combineArray(val, tag, otherFn)
	{
		//var sArray = [];
		var s = "";
		val.find(tag).each(function(i){
			//sArray.push($(this).text());
			var t = formatString($(this).text());
			if (otherFn != undefined) t = otherFn(t);
			s += t + " ";
		})
		s = $.trim(s);
		return s;
	}
	
	function getSeason(m)
	{
		
	}
	
	function printObj(obj)
	{
		$("#objDetail tr").remove();
		for (var v in obj)
		{
			var t = "<tr><td>" + v + "</td><td>" + obj[v] + "</td><td>";			
			$("#objDetail").append(t);
		}
	}
	
})
