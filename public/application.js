(function($) {
  $.fn.slideshow = function(opts) {

    // Setup default settings
    var settings = $.extend({
      nextIn: 5000
    }, opts);
    var listenersAttached = false;
    var thumbs = $(this);
    var nextTimeout = null;

    // Display full size as background
    var pickImg = function(event) {
      var el = $(event.target);
      thumbs.removeClass('picked');

      // show picked main image
      var pickedId = el.data('id');
      var newImgUrl = el.data('large');
      $('html').css({
        'background': 'url(' + newImgUrl + ') no-repeat top left fixed',
        'background-size': 'cover'
      });
      $('#thumb-' + pickedId).addClass('picked');

      // setup next
      if (nextTimeout > 0) {
        clearTimeout(nextTimeout);
      }
      nextTimeout = setTimeout(function(){
        var next = $('.picked').next();
        var first = false;
        if (next.length === 0) {
          next = $('.picked').siblings().first();
          first = true;
        }
        next.click();

        // scrollLeft the slideshow
        var nextScroll = next.position().left - $(document).innerWidth();
        if (nextScroll > 0) {
          thumbs.parent().scrollLeft(nextScroll + $(document).innerWidth());
        }
        if (first) {
          thumbs.parent().scrollLeft(0);
        }
      }, settings.nextIn);
    };

    // Protect against multiple invocations
    if (!listenersAttached) {
      thumbs.click(pickImg);

      // preload larger images
      thumbs.each(function(idx, element){
        var img = new Image().src = $(element).data('large');
        $('.main').append(img).hide();
      });
      listenersAttached = true;
      thumbs.first().click();
    }

    return this;
  };
})(jQuery);

$(function(){
  window.slideshow = $('.thumb').slideshow();
});