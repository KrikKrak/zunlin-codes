/**
 * @author Larry
 */

$(document).ready (function(){
	
	/* put page init function here */
	//alert("page load...");
	$("#dish_detail_panel").hide();
	
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
	
	$("#btnEdit").click (function()
	{
		open("edit?key=" + curDetailKey, "_self");
	})
	
	$("#btnDel").click (function()
	{
		var d = confirm("确认删除?");
		if (d == true)
		{
			removeRecipe(curDetailKey);
		}
	})
	
	// var define
	var result_table_head_str = "<tr><th width='200' scope='col'>菜名</th><th width='80' scope='col'>类别</th><th width='80' scope='col'>种类</th><th width='160' scope='col'>级别</th><th width='80' scope='col'>使用次数</th></tr>";
	
	var dataCount = 0;
	var fromIdx = 0;
	var curFetchLengh = 0;
	var curFilter = "";
	
	var localData = [];
	var curDetailKey = "";
	
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
		
		localData.splice(0, localData.length);
		
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
			localData.push(r.id);
		}
		
		if (fromIdx + curFetchLengh < dataCount)
		{
			$("#nextBtn_panel").show();
		}
		
		// format table to make it a little nicer
		$("#result_table tr:odd").css("background-color", "#CCCCCC");
		
		// add table row click listener
		$("#result_table tr").click(dishClick);
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
		curDetailKey = localData[t.rowIndex - 1];
		getDetailbyKey(curDetailKey);
	}
	
	function getDetailbyKey(key)
	{
		$.ajax({
			type: "GET",
			url: "/postnew",
			data: "key=" + key,
			success: getDetailbyKeyResult
		})
	}
	
	function getDetailbyKeyResult(data)
	{
		if (data == "error") return;
		
		var obj = $.json.decode(data)
		for (var i in obj["data"])
		{
			// there should be only one item here
			var r = obj["data"][i];

			$("#d_name").text(r.name);
			$("#d_category").text(r.category);
			$("#d_type").text(r.type);
			$("#d_hot").text((r.hot == true) ? "是" : "否");
			$("#d_count").text(r.count);
			$("#d_month").text(getSeason(r.sprint, r.summer, r.fall, r.winter));
			$("#d_combine").text(r.combine);
			$("#d_rate").text(r.rate);
			$("#d_source").text(r.source);
			$("#d_other").text(r.other);
			if (r.imgurl != null && r.imgurl != "")
			{
				$("#recipe_img").attr("src", r.imgurl);
				$("#recipe_img").show();
			}
			else
			{
				$("#recipe_img").hide();
			}
			
			break;
		}
		openDishDetail();
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
	
	function removeRecipe(key)
	{
		$.ajax({
			type: "POST",
			url: "/delete",
			data: "key=" + key,
			success: removeRecipeResult
		})
	}
	
	function removeRecipeResult(data)
	{
		if (data == "done")
		{
			// close the detail dialog
			$("#dish_detail_panel").dialog("close");
			// re-search the result
			updateDishs();
		}
		else if (data == "error")
		{
			alert("error");
		}
	}
	
	// ======================================
	// [HELP FUNCTION]
	
	function getSeason(sp, su, fa, wi)
	{
		var s = "";
		if (sp == true)
		{
			s += "春";
		}
		if (su == true)
		{
			s += " 夏";
		}
		if (fa == true)
		{
			s += " 秋";
		}
		if (wi == true)
		{
			s += " 冬";
		}
		return s;
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
