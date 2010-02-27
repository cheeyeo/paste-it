$(document).ready(function()
{
	var orig = $("#snippet-description").val();
	//extend jquery ajax request to handle put/delete requests
	function _ajax_request(url, data, callback, type, method) {
	    if (jQuery.isFunction(data)) {
	        callback = data;
	        data = {};
	    }
	    return jQuery.ajax({
	        type: method,
	        url: url,
	        data: data,
	        success: callback,
	        dataType: type
	        });
	}

	jQuery.extend({
	    put_: function(url, data, callback, type) {
	        return _ajax_request(url, data, callback, type, 'PUT');
	    },
	    delete_: function(url, data, callback, type) {
	        return _ajax_request(url, data, callback, type, 'DELETE');
	    }
	});
	
	
	$("#embed-link").click(
	function()
	{
	  $("#embed-box").show();
	  $(this).hide();	
	});
	
	$("#embed-box").blur(function(){
		$(this).hide();
		$("#embed-link").show();
	});
	
	
	$("#snippet-edit-button").toggle(
	  function()
	  {
		$("#snippet-description").hide();
		$("#test").show();
		$("#edit-block").show();
		$(this).html('cancel');
	  
 	  },
	  function()
	  {
		$("#snippet-description").show();
		$("#test").hide();
		$("#edit-block").hide();
		$(this).html('edit');
 	  }
     );
	
	$(".name-file").click(
		function()
		{
			$(".snippet-name-textbox").show();
			$(this).hide();
			$(".gist-lang").hide();
			$(".gist-lang-desc").show();
		}
	);

	
	
	$(".snippet-name-textbox").blur(function(){
	  //alert('TEST');
	  if ($(this).val()){
		//alert('has value');
		$(".name-file").html($(this).val());
		//$(".gist-lang").show();
	  }else{
		$(".gist-lang").show();
		$(".gist-lang-desc").hide();
		$(".name-file").html('File Name (not required)');
	  }
	  $(this).hide();
	  $(".name-file").show();
	});


	
	$("#update-snippet").click(
	function()
	{
		//alert('here!');
	    var desc = $("#test").val();
		var id = $("#snippet-id").val();
		//ajax call
		//alert(id);
		//alert(desc);
		$.ajax({
	      type: "GET",
		  url: "/snippets/update_cat",
		  data: {'desc':desc, 'id':id}, 
		  success:function(t){
	        $("#snippet-description").show();
			$("#snippet-description").html(desc);
			$("#edit-block").hide();
			$("#snippet-edit-button").html('edit');
		  },
		   error:function(t){
			alert(t);
		  }
        });//end ajax call
			return false;
	  	
	});
	
});//end document