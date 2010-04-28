/**
 * @author Larry
 */

 $(document).ready (function(){
 	
	$("#errorHead").hide();
	
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
