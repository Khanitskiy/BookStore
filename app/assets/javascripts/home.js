var ready;
ready = (function() {
    $("#owl-demo").owlCarousel({
        navigation : true,
        slideSpeed : 300,
        paginationSpeed : 400,
        singleItem:true,
    });

});
$(document).ready(ready);
$(document).on('page:load', ready);