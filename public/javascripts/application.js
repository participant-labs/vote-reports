// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//

;(function($) {
  
  // $(function(){
  // 
  //   // Bind the event.
  //   $(window).bind( 'hashchange', function(){
  //     // Alerts every time the hash changes!
  //     alert( location.hash );
  //   })
  // 
  // });
  
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
      $.each($(event.target).attr('data-toggle').split(', '), function() {
        $('#' + this).toggle();
      })
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

  $current_tabs = $(".ui-tabs").tabs();
  
  var tabs = $('.ui-tabs'),

  tab_a_selector = 'ul.ui-tabs-nav a';
  tabs.tabs({ event: 'change' });

  // Define our own click handler for the tabs, overriding the default.
  tabs.find( tab_a_selector ).click(function(){
    var state = {},

    // Get the id of this tab widget.
    id = $(this).closest( '.ui-tabs' ).attr( 'id' ),

    // Get the index of this tab.
    idx = $(this).parent().prevAll().length;

    // Set the state!
    state[ id ] = idx;
    $.bbq.pushState( state );
  });

  // Bind an event to window.onhashchange that, when the history state changes,
  // iterates over all tab widgets, changing the current tab as necessary.
  $(window).bind( 'hashchange', function(e) {

    // Iterate over all tab widgets.
    tabs.each(function(){
      var idx = $.bbq.getState( this.id, true ) || 0;
      $(this).find( tab_a_selector ).eq( idx ).triggerHandler( 'change' );
    });
  })

  $(window).trigger( 'hashchange' );

 
  
  
})(jQuery);