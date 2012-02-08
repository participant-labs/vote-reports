//= require jquery-ui-1.8.16.custom.min
//= require jquery.ui.autocomplete
//= require jquery.enumerable
//= require jquery.blockUI
//= require jquery.hoverIntent
//= require jquery.defaultvalue
//= require jquery.Jcrop
//= require jquery.cookie
//= require tipsy_titles
//= require highcharts/highcharts.src
//= require faceboxy
//= require rails
//= require replace
//= require geolocation

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

  $(function(){
    $('.flash.success, .flash.notice, .flash.message').fadeOutSoon(3000);
    $('.flash.error, .flash.warning').fadeOutSoon(5000, 5000);

    $('.selectable').live('update_selected', function(event) {
      $(event.target).closest('.selectable').toggleClass('selected');
      return true;
    });

    $('a.act-toggle').live('click', function(event) {
      $.each($(event.target).attr('rel').split(' '), function() {
        $('#' + this).toggle();
      })
      return false;
    });

    $('.act-tab-select').live('click', function(event) {
      $current_tabs.tabs('select', $(event.target).attr('rel'));
      return false;
    });

    $('.act-hover').hoverIntent({
      timeout: 500,
      over: function() {
        $('#' + $(this).attr('rel')).fadeIn();
      },
      out: function() {
        $('#' + $(this).attr('rel')).fadeOut();
      }
    });

    $('[placeholder]').defaultValue();
    $('label.placeholder').hide();

    $("#nav_search").autocomplete({
      source: "/search",
      minLength: 2,
      html: true,
      select: function(event, ui) {
        window.location = ui.item.path;
      }
    });
  });

  $current_tabs = $(".ui-tabs").tabs({cookie: {expires: 30, name: $('.ui-tabs').attr('id')}});

  $.ajaxSettings.accepts.html = $.ajaxSettings.accepts.script;
  $.ajaxSetup({
    beforeSend: function(xhr) {
      xhr.setRequestHeader("Accept", "text/javascript");
    }
  });
})(jQuery);
