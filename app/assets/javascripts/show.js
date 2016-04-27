$(document).on("ready page:load",function(){  

  $('input.star').rating();
  $('.rating_comment').css("display","none");

  $('body').delegate('a#open_comment_rating', 'click', function(){
    $('.rating_comment').show("500");
    $('#open_comment_rating').css("display","none");
    $('.no-reviwes-message').hide("500");
    return false;
  });

  $('body').delegate('a#cancel', 'click', function(){
    $('.rating_comment').hide("500");
    $('#open_comment_rating').css("display","block");
    $('.no-reviwes-message').show("500");
    return false;
  });

  $('body').delegate('.star-rating-control .star', 'click', function(){
    $('input.hidden_input').val($('a',this).attr('title'));
  });

  //$('body').delegate('.rating-cancel a', 'click', function(){
    //$('input.hidden_input').val('');
  //});


  $('body').delegate('#add_comment_reting', 'click', function(){
    var pathname = $(location).attr('host') + '/rating';
    var rating = $('.hidden_input').val();
    var title  = $('.field_title').val();
    var text_review = $('.field_comment').val();
    var user_id = $('.hidden_input_userid').val();
    var book_id = $('.hidden_input_bookid').val();
    //if (rating == '') { rating = '10'; }
    $.ajax({
      type: "POST",
      url: "http://" + pathname,
      data: "rating="       + rating  + 
            "&title="       + title   +
            "&text_review=" + text_review +
            "&user_id="     + user_id + 
            "&book_id="     + book_id,

      success: function(msg){
        if(msg == 'It broke!') {
          alert("Fill in all the fields or enter the true test values")
        }
        else {
          $('.rating_comment').hide("500");
          $( ".comments-block" ).prepend( msg );

          var id_comment = $('#id_comment').text();
          $("input.star" + id_comment).rating();

          $( ".comments-block .my_hide" ).show(700);
        }
      },
      error:function(msg){
          alert("Error");
      } 
    });

    return false;
  });

});