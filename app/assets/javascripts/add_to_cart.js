$(document).on("ready page:load",function(){

  $(".add_book").click(function(){  

      var book_id = $(this).attr('id').replace("button_book_id_","");
      var quantity = $('.quantity_id_' + book_id).val();
      var count =  $('.cart-lnk em').text().slice(1, -1);

      if ($('#current_user').text()) {

        count = ajaxChange(book_id, quantity);

      } else {
        count = changeCookie(book_id, quantity);
      }


      var position_obj = $(".cart-lnk").position();
      var now_element = $(".book_id_" + book_id + " img").offset();

       $(".book_id_" + book_id + " img")  
        .clone()
        .prependTo("body") 
        .css({'position' : 'absolute', 'top' : now_element.top + 'px', 'left' : now_element.left + 'px', 'z-index': '100', }) 
        .appendTo("body")  
        .animate({opacity: 0.5,   
                      top: 1, 
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