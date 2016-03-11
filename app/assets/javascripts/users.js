// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on("ready page:load",function(){


	if($('#address_checkbox').val() == 1) {
		$('#shipping_address').hide(300);
		$("#address_checkbox").prop( "checked", true );
	} else {
		$('#shipping_address').show(200);
	}

	$("#address_checkbox:checkbox").change(function(){
	  if(this.checked){
	      $('#shipping_address').hide(300);
	       $('#address_checkbox').val('1');
	  } else{
	      $('#shipping_address').show(200);
	      $('#address_checkbox').val('0');
	  }
	});

});