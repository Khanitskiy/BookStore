function ajaxChange(book_id, quantity) {
  var data = { book_id: book_id, quantity: quantity }
  ajaxRequest("http://" + window.location.host + "/order_items/" + book_id, data, "PATCH");
  var cookie_values = document.cookie.replace(/(?:(?:^|.*;\s*)user_products_count\s*\=\s*([^;]*).*$)|^.*$/, "$1");
  
  if(cookie_values) {
    var obj = jQuery.parseJSON(decodeURIComponent(cookie_values));
  } else {
    var obj = Object.create(null)
    obj["count"] = $('.cart-lnk em').text().slice(1, -1) == 'empty' ? 0 : $('.cart-lnk em').text().slice(1, -1);
  }

  var count = parseInt(obj["count"]);
  count =  count +  parseInt(quantity);
  setCookie("user_products_count", "{\"count\" : \"" + count + "\"}");

  return count;
}

function ajaxRequest(path, data, method) {
    $.ajax({
      type: method,
      url: path ,
      data: data,
      dataType: 'json',
      success: function(msg){
        //return true;
      },
      error:function(msg){
        //return false;
      } 
    });
}