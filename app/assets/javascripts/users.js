// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on("ready page:load",function(){

  if ($( "#shipping_error" ).hasClass( "has_errors" )) {
    $('#address_checkbox').val('0');
    $('#shipping_address').show(200);
    $("#address_checkbox").prop( "checked", false );
  }

  if($('#address_checkbox').val() == 1) {
      $('#shipping_address').hide();
      $("#address_checkbox").prop( "checked", true );
  } else {
      $('#shipping_address').show();
  }

  $("#address_checkbox:checkbox").change(function(){
    if(this.checked){
        $('#shipping_address').hide(300);
        $('#address_checkbox').val('1');
        $("#address_and_shipping").val( "true" );
    } else{
        $('#shipping_address').show(200);
        $('#address_checkbox').val('0');
        $("#address_and_shipping").val( "false" );
    }
  });



  if($('#remove_accaunt_checkbox').val() == 'false') {
      $('#remove_button').addClass('disabled');
      $("#remove_accaunt_checkbox").prop( "checked", false );
  }

  $("#remove_accaunt_checkbox:checkbox").change(function(){
    if(this.checked){
        $('#remove_button').removeClass('disabled');
        $('#remove_accaunt_checkbox').val('true');
    } else{
        $('#remove_button').addClass('disabled');
        $('#remove_accaunt_checkbox').val('false');
    }
  });

  $('body').delegate('#remove_button', 'click', function(){

    if ($(this).hasClass('disabled')){
      return false;
    }

  });

});

