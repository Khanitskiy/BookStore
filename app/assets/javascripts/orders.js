// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on("ready page:load",function(){
			

		// ## Delete product
		$('body').delegate('.remove_link a', 'click', function(){
			var product_id = $(this).attr('id');
			var product_count;
			var total_price = 0;
			$(this).parents('tr').find( ".total" ).removeClass();
			$(this).parents('tr').hide(500);

			var cookie_value = document.cookie.replace(/(?:(?:^|.*;\s*)books\s*\=\s*([^;]*).*$)|^.*$/, "$1");

			if (cookie_value) {
				var obj = jQuery.parseJSON(decodeURIComponent(cookie_value));
				product_count = parseInt(obj[product_id]);

				// Change count products in shop carts
				$('.cart-lnk em').text("(" + (parseInt($('.cart-lnk em').text().slice(1, -1)) - product_count) + ")");
				if ($('.cart-lnk em').text() == '(0)' ) {$('.cart-lnk em').text('(empty)')}

				//Change total price
				$( ".total" ).map(function(index, element) {
					total_price += parseFloat($(this).text().substring(1, $(this).text().length));
				});
				$('.order-summary-line span').text(number_to_currency(total_price));


				// Delete cookies
				delete obj[product_id];
				obj['book_count'] =  obj['book_count'] - product_count;
				if (obj['book_count'] == '0') { 
					deleteCookie('books') 
					$('.full_cart').hide(300).delay(2000)
					$('.cart_empty').show(300).delay(3000).fadeIn( 500 );
				} else {
					setCookie(JSON.stringify(obj));
				}
			}
		});

		
		// ## Update shop cart
		$('body').delegate('#update', 'click', function(){

			var price, qty, total, total_price = 0;
			//Change total price
			$( ".tr" ).map(function(index, element) {

				price = $(this).find('.book_price').text().substring(1, $(this).text().length);
				qty = $(this).find('.count input').val();
				total = price * qty;
				total_price = total_price + total;
				
				$(this).find('.total').text(number_to_currency(total));
				

			});
			$('.order-summary-line span').text(number_to_currency(total_price));

		});



});