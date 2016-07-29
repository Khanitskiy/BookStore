
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

function setCookie(name, value) {
  var expireDate = new Date();
  expireDate.setDate(expireDate.getDate() + 31);

  document.cookie= name + '= '+ encodeURIComponent(value) +' ; expires=' + expireDate.toGMTString() + '; path=/';
}

function deleteCookie(name) {
  document.cookie = name +'=; Path=/; Expires=Thu, 01 Jan 1970 00:00:01 GMT;';
}


function changeCookie(book_id, quantity) {
  var count = document.cookie.replace(/(?:(?:^|.*;\s*)book_count\s*\=\s*([^;]*).*$)|^.*$/, "$1");
  var cookie_values = document.cookie.replace(/(?:(?:^|.*;\s*)books\s*\=\s*([^;]*).*$)|^.*$/, "$1");
  if (count) {
    var count = jQuery.parseJSON(decodeURIComponent(count));
    var obj = jQuery.parseJSON(decodeURIComponent(cookie_values));
    if (obj[book_id] != undefined) {
      obj[book_id] = (+quantity + parseInt(obj[book_id])).toString();
    } else {
      obj[book_id] = quantity;
    }
    count.book_count = +count.book_count + parseInt(quantity);
    setCookie("book_count", '{"book_count" :' +'"'+count.book_count+'"}');
    setCookie("books", JSON.stringify(obj));
    return count.book_count;
  } else {
    setCookie("book_count",'{"book_count" : "' + quantity + '"}');
    setCookie("books",'{"' + book_id + '":"' + quantity + '"}');
    
    return quantity;
  }

}

function updateCookie(data, quantity) {
  var count = document.cookie.replace(/(?:(?:^|.*;\s*)book_count\s*\=\s*([^;]*).*$)|^.*$/, "$1");
  var cookie_values = document.cookie.replace(/(?:(?:^|.*;\s*)books\s*\=\s*([^;]*).*$)|^.*$/, "$1");

  var count = jQuery.parseJSON(decodeURIComponent(count));
  var cookie_values = jQuery.parseJSON(decodeURIComponent(cookie_values));
  console.log(count);
  for (var key in data) {
    cookie_values[key] = data[key];
  }

  count.book_count = quantity

  setCookie("book_count", JSON.stringify(count));
  setCookie("books", JSON.stringify(cookie_values));
  return count.book_count;
}

function ajaxChange(book_id, quantity) {
  var data = { book_id: book_id, quantity: quantity }
  ajaxRequest("http://" + window.location.host + "/order_items/" + book_id, data, "PATCH");
  //alert("http://" + window.location.host + "/orders_items/" + book_id, data, "PATCH")
  var cookie_values = document.cookie.replace(/(?:(?:^|.*;\s*)user_products_count\s*\=\s*([^;]*).*$)|^.*$/, "$1");
  
  if(cookie_values) {
    var obj = jQuery.parseJSON(decodeURIComponent(cookie_values));
  } else {
    var obj = Object.create(null)
    obj["count"] = $('.cart-lnk em').text().slice(1, -1) == 'empty' ? 0 : $('.cart-lnk em').text().slice(1, -1);
  }

  console.log(obj);
  var count = parseInt(obj["count"]);
  console.log(count);
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
        console.log(msg)
      } 
    });
}

$(document).on("ready page:load",function(){

  $(".add_book").click(function(){  

      var book_id = $(this).attr('id').replace("button_book_id_","");
      var quantity = $('.quantity_id_' + book_id).val();
      var count =  $('.cart-lnk em').text().slice(1, -1);

      if ($('#current_user').text()) {

        count = ajaxChange(book_id, quantity);

      } else {
        // Set cookies
        count = changeCookie(book_id, quantity);
        console.log(parseInt($('.cart-lnk em').text().slice(1, -1)));
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