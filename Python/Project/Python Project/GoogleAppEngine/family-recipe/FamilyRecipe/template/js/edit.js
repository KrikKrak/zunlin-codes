/**
 * @author Larry

 */
 $(document).ready (function(){
 	
	$("#errorHead").hide();
	$("#info_hide").hide();
	
	// prepare check box
	PrepareCheckBox($("#lb_hot"), $("#ip_hot"));
	PrepareCheckBox($("#lb_sprint"), $("#ip_sprint"));
	PrepareCheckBox($("#lb_summer"), $("#ip_summer"));
	PrepareCheckBox($("#lb_fall"), $("#ip_fall"));
	PrepareCheckBox($("#lb_winter"), $("#ip_winter"));

	// prepare option
	PrepareSelection($("#ip_category")[0], $("#lb_cate").text());
	PrepareSelection($("#ip_type")[0], $("#lb_type").text());
	
	// prepare rate
	$("#ip_r1").removeAttr("checked");
	$("#ip_r2").removeAttr("checked");
	$("#ip_r3").removeAttr("checked");
	$("#ip_r4").removeAttr("checked");
	$("#ip_r5").removeAttr("checked");
	switch ($("#lb_rate").text())
	{
		case "1":
			$("#ip_r1").attr("checked", "checked");
			break;
			
		case "2":
			$("#ip_r2").attr("checked", "checked");
			break;
			
		case "3":
			$("#ip_r3").attr("checked", "checked");
			break;
			
		case "4":
			$("#ip_r4").attr("checked", "checked");
			break;
			
		case "5":
			$("#ip_r5").attr("checked", "checked");
			break;
	}
		
	function PrepareSelection(obj, tag)
	{
		var len = obj.options.length;
		for (var i = 0; i < len; ++i)
		{
			if (obj.options[i].value == tag)
			{
				obj.options[i].selected = true;
			}
		}
	}
	
	function PrepareCheckBox(lb, obj)
	{
		if (lb.text() == "True")
		{
			obj.attr("checked", "checked");
		}
		else if (lb.text() == "False")
		{
			obj.removeAttr("checked");
		}
	}
	
	
	$("#form_basic_info").validate({
		//debug: true,
		rules: {
			ip_name: {
				required: true
			},
			ip_count: {
				required: true,
				digits: true
			}
		},
		messages: {
			ip_name: "请输入菜名",
			ip_count: "请输入使用次数"
		},
		//errorClass: "formHint",
		//errorElement: "span",
		//wrapper: "p",
		invalidHandler: function(form, validator){
			var errors = validator.numberOfInvalids();
			if (errors)
			{
				var msg = "You have " + errors + "error input to fix!";
				$("#errorHead").slideDown(500);
			}
			else
			{
				$("#errorHead").hide();
			}
		},
		
		errorPlacement: function(error, element){
			if (element.parent("div").find("label").length == 1)
			{
				error.addClass("formHint");
				error.addClass("errorElement");
				error.removeClass("error");
				error.appendTo(element.parent("div"));
			}
		},
		/*
		submitHandler: function(){
			alert("Form is validated!");
		},
		*/
	});
	
	$("#ip_name").focus();
	
 })
