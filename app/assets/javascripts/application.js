// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require turbolinks
//= require owl.carousel
//= require_tree .
//= require jquery-star-rating


function number_to_currency(number, options) {
  try {
    var options   = options || {};
    var precision = options["precision"] || 2;
    var unit      = options["unit"] || "$";
    var separator = precision > 0 ? options["separator"] || "." : "";
    var delimiter = options["delimiter"] || ",";
  
    var parts = parseFloat(number).toFixed(precision).split('.');
    return unit + number_with_delimiter(parts[0], delimiter) + separator + parts[1].toString();
  } catch(e) {
    return number;
  }
}

function number_with_delimiter(number, delimiter, separator) {
  try {
    var delimiter = delimiter || ",";
    var separator = separator || ".";
    
    var parts = number.toString().split('.');
    parts[0] = parts[0].replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1" + delimiter);
    return parts.join(separator);
  } catch(e) {
    return number
  }
}

function setCookie(value) {
	var expireDate = new Date();
	expireDate.setDate(expireDate.getDate() + 31);

	document.cookie='books= '+ encodeURIComponent(value) +' ; expires=' + expireDate.toGMTString() + '; path=/';
}

function deleteCookie(name) {
	document.cookie = name +'=; Path=/; Expires=Thu, 01 Jan 1970 00:00:01 GMT;';
}


function changeCookie(book_id, quantity) {
	var cookie_value = document.cookie.replace(/(?:(?:^|.*;\s*)books\s*\=\s*([^;]*).*$)|^.*$/, "$1");

	if (cookie_value) {
		var obj = jQuery.parseJSON(decodeURIComponent(cookie_value));

		if (obj["id_" + book_id] != undefined) {
			obj["id_" + book_id] = (+quantity + parseInt(obj["id_" + book_id])).toString();
		} else {
			obj["id_" + book_id] = quantity;
		}

		obj.book_count = (+quantity + parseInt(obj.book_count)).toString();

		setCookie(JSON.stringify(obj));

		return obj.book_count;

	} else {
		setCookie("{\"book_count\" : \"" + quantity + "\", \"id_" + book_id + "\":\"" + quantity + "\"}");
		
		return quantity;
	}

}



$(document).on("ready page:load",function(){

	$(".add_book").click(function(){  

			var book_id = $(this).attr('id').replace("button_book_id_","");
			var quantity = $('.quantity_id_' + book_id).val();

			// Set cookies
			var count = changeCookie(book_id, quantity);

			var position_obj = $(".cart-lnk").position();
			var now_element = $(".book_id_" + book_id + " img").offset();

       $(".book_id_" + book_id + " img")  
        .clone()
        .prependTo("body") 
        .css({'position' : 'absolute', 'top' : now_element.top + 'px', 'left' : now_element.left + 'px', 'z-index': '100', }) 
        .appendTo("body")  
        .animate({opacity: 0.5,   
                      top: 1, /* Важно помнить, что названия СSS-свойств пишущихся  
                      через дефис заменяются на аналогичные в стиле "camelCase" */  
                      left: position_obj.left+ 100,
                      width: 50,   
                      height: 50}, 700, function() {  
              $(this).remove();  

              var count_products = ($('.cart-lnk em').text()).slice(1, -1);

              if (count >= 100) {
              	$(".cart-lnk em").text("(99+)") 
              } else {
              	$(".cart-lnk em").text("(" + count + ")");
              } 
        }); 
    return false; 
   });  

});


