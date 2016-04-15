// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/





$(document).on("ready page:load",function(){


  if($('#order_steps_form_shipping_address_checkbox').val() == 1) {
      $('#shipping_address_step').hide();
      //$("#order_steps_form_shipping_address_checkbox").prop( "checked", true );
  } else {
      $('#shipping_address').show();
      $('.ship-address-form-fields').show();
      $('#order_steps_form_billing_address_and_shipping').val('false')
  }

  $("#order_steps_form_shipping_address_checkbox:checkbox").change(function(){
    if(this.checked){
        $('#shipping_address_step').hide(300);
        $('#order_steps_form_shipping_address_checkbox').val('1');
        $("#order_steps_form_billing_address_and_shipping").val( "true" );
    } else{
        $('#shipping_address_step').show(200);
        $('#order_steps_form_shipping_address_checkbox').val('0');
        $("#order_steps_form_billing_address_and_shipping").val( "false" );
    }
  });

  $('body').delegate('#order_steps_form_delivery_type_delivery_5', 'click', function(){
    $('.shipping span').text('$5.00')
    $('.order_total span').text(number_to_currency(+$('.item_total span').text().slice(1) + 5))
  });

  $('body').delegate('#order_steps_form_delivery_type_delivery_10', 'click', function(){
    $('.shipping span').text('$10.00')
    $('.order_total span').text(number_to_currency(+$('.item_total span').text().slice(1) + 10))
  });

  $('body').delegate('#order_steps_form_delivery_type_delivery_20', 'click', function(){
    $('.shipping span').text('$20.00')
    $('.order_total span').text(number_to_currency(+$('.item_total span').text().slice(1) + 20))
  });


});