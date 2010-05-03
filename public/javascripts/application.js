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

  $(document).ready(function(){
    $('.flash.success, .flash.notice, .flash.message').fadeOutSoon(3000);
    $('.flash.error, .flash.warning').fadeOutSoon(5000, 5000);

    $('.selectable').live('update_selected', function(event) {
      $(event.target).closest('.selectable').toggleClass('selected');
      return true;
    });

    $('[data-dialog]').live('mouseover', function() {
      var target = $('#' + $(this).attr('data-dialog'));
      target.dialog({
        autoOpen: false,
        title: target.attr('data-dialog-title'),
        width: target.attr('data-dialog-width') || 740});
    });
    $('[data-dialog]').live('click', function(event) {
      $('#' + $(event.target).attr('data-dialog')).dialog('open');
      return false;
    });

    $('[data-toggle]').live('click', function(event) {
      $('#' + $(event.target).attr('data-toggle')).toggle();
      return false;
    });

    $('[data-tab-select]').live('click', function(event) {
      $current_tabs.tabs('select', $(event.target).attr('data-tab-select'));
      return false;
    });

    $('.hoverable, .dropdown').live('mouseover', function() {
      var self = $(this);
      if (!self.data('init')) {
        self.data('init', true);
        self.hoverIntent({
          timeout: 500,
          over: function() { $(this).addClass("hovering"); },
          out: function() { $(this).removeClass("hovering"); }
        });
        self.mouseover();
      }
    });

    $('.fieldtag').fieldtag();
    $('label.fieldtag').hide();

  });
  $.ajaxSettings.accepts.html = $.ajaxSettings.accepts.script;

  $current_tabs = $(".tabbed-nav").tabs();
})(jQuery);
