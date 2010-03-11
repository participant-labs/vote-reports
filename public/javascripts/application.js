// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//
;(function($) {
  $.fn.fadeOutSoon = function(when, length) {
    if (typeof when == "undefined") when = 5000;
    if (typeof length == "undefined") length = 1000;
    var self = $(this);
    setTimeout(function() {
      self.fadeOut(length)
    }, when);
    return self;
  };

  function replaceWith(target, url) {
    target = $(target);
    if (target.length == 0) {
      return true;
    }
    target.block({message: '<p class="loading">Loading...</p>'});
    target.load(url, function() {
      target.unblock();
    });
    return false;
  }

  $(document).ready(function(){
    $('.flash.notice, .flash.message').fadeOutSoon(3000);
    $('.flash.error, .flash.warning').fadeOutSoon(5000, 5000);

    $('[data-dialog]').live('mouseover', function() {
        $($(this).attr('data-dialog')).dialog({
          autoOpen: false,
          title: $(this).attr('data-dialog-title'),
          width: $(this).attr('data-dialog-width') || 740});
    });
    $('[data-dialog]').live('click', function(event) {
        $($(event.target).attr('data-dialog')).dialog('open');
        return false;
    });

    $('[data-toggle]').live('click', function(event) {
      $($(event.target).attr('data-toggle')).toggle();
      return false;
    })

    $('[data-replace] > a, a[data-replace]').live('click', function(event) {
      var target = $(event.target);
      return replaceWith(target.closest('[data-replace]').attr('data-replace'), target.attr('href'));
    })

    $('form[data-replace]').submit(function(event){
      var source = $(event.target);
      return replaceWith(source.attr('data-replace'), source.attr('action') + '?' + source.serialize());
    });

    $('.hoverable, .dropdown').live('mouseover', function() {
      if (!$(this).data('init')) {
        $(this).data('init', true);
        $(this).hoverIntent({
          timeout: 500,
          over: function() { $(this).addClass("hovering"); },
          out: function() { $(this).removeClass("hovering"); }
        });
        $(this).trigger('mouseover');
      }
    });

     $('#mce-EMAIL').fieldtag();
     $('[for=mce-EMAIL]').hide();

  });
  $.ajaxSettings.accepts.html = $.ajaxSettings.accepts.script;
})(jQuery);
