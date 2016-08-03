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
  for (var key in data) {
    cookie_values[key] = data[key];
  }

  count.book_count = quantity

  setCookie("book_count", JSON.stringify(count));
  setCookie("books", JSON.stringify(cookie_values));
  return count.book_count;
}