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
	
	$("#btnNextPage").click (function()
	{
		var d = curFilter;
		if (curFilter != "")
		{
			d += "&";
		}
		d += "fromidx=" + (fromIdx + curFetchLengh) + "&len=" + 10;
		
		// update dishs to table
		$("#result_table tr").remove();

		loadData(d);
	})
	
	// var define
	var result_table_head_str = "<tr><th width='200' scope='col'>菜名</th><th width='80' scope='col'>类别</th><th width='80' scope='col'>种类</th><th width='160' scope='col'>级别</th><th width='80' scope='col'>使用次数</th></tr>";
	
	var dataCount = 0;
	var fromIdx = 0;
	var curFetchLengh = 0;
	var curFilter = "";
	
	// disable all select options
	$("#cb_type").attr("disabled", "true");
	$("#cb_season").attr("disabled", "true");
	$("#cb_rate").attr("disabled", "true");
	
	// load xml file
	loadData();

	// work function
	function loadData(d)
	{
		$.ajax({
			type: "GET",
			url: "/postnew",
			data: d,
			success: dataLoaded
		})
	}
	
	function dataLoaded(data)
	{
		$("#nextBtn_panel").hide();
		// add talbe head
		$("#result_table").append(result_table_head_str);
		if (data == "error") return;
		
		var obj = $.json.decode(data)
		dataCount = obj["count"];
		fromIdx = obj["start"];
		curFetchLengh = obj["length"];

		var i = 0;
		for (var i in obj["data"])
		{
			var r = obj["data"][i];
			
			var dishName = r.name;
			var category = r.category;
			var dishType = r.type;
			var rate = r.rate;
			var usedTimes = r.count;
			
			var t = "<tr><td>" + dishName + "</td><td>"
								+ category + "</td><td>"
								+ dishType + "</td><td>"
								+ rate + "</td><td>"
								+ usedTimes + "</td></tr>";
								
			$("#result_table").append(t);
			
			i++;
		}
		
		if (fromIdx + curFetchLengh < dataCount)
		{
			$("#nextBtn_panel").show();
		}
		
		// format table to make it a little nicer
		$("#result_table tr:odd").css("background-color", "#CCCCCC");
		
		// add table row click listener
		//$("#result_table tr").click(dishClick);
	}
	
	function updateDishs()
	{
		// find related dishs
		var d;
		if ($("#ip_show_all")[0].checked == true)
		{
			d = "";
		}
		else
		{
			d = getFilterString($("#cb_type")[0].value, $("#cb_season")[0].value, $("#cb_rate")[0].value);
		}
		
		// update dishs to table
		$("#result_table tr").remove();
		
		curFilter = d;
		loadData(d);
	}
	
	function getFilterString(type, season, rate)
	{
		var s = "";
		if (type != "all")
		{
			s = "cat=" + type;
		}
		
		if (season != "all")
		{
			s += "&season=" + season;
		}
		
		if (rate != "all")
		{
			s += "&rate=" + rate;
		}

		return s;
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
		if (m == "1")
		{
			return "春";
		}
		if (m == "2")
		{
			return "夏";
		}
		if (m == "3")
		{
			return "秋";
		}
		if (m == "4")
		{
			return "冬";
		}
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
