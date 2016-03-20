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


$(document).on("ready page:load",function(){

	$(".add_book").click(function(){  

			var book_id = $(this).attr('id').replace("button_book_id_","");

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
        }); 
    return false; 
   });  

});


