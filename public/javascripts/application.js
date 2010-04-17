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

  $.address.init(function(event) {
    if (event.value.length > 1) {
      var values = event.value.substring(1).split('/');
      var target_id = values.shift();
      var url = current_url() + '?' + values.shift();
      replaceWith(target_id, url);
    }
  });

  function current_url() {
    return window.location.protocol + '//' + window.location.host + window.location.pathname;
  }

  function params_to_path(target_id, url) {
    return target_id + '/' + url.substring(url.indexOf('?') + 1);
  }

  function replaceWith(target_id, url) {
    target = $('#' + target_id);
    if (target.length == 0) {
      return true;
    }
    target.block({message: '<p class="loading">Loading...</p>'});
    target.load(url, function() {
      target.unblock();
    });
    $.address.value(params_to_path(target_id, url));
    return false;
  }

  $(document).ready(function(){
    $('.flash.success, .flash.notice, .flash.message').fadeOutSoon(3000);
    $('.flash.error, .flash.warning').fadeOutSoon(5000, 5000);

    $('.selectable').live('update_selected', function(event) {
      $(event.target).closest('.selectable').toggleClass('selected');
      return true;
    });

    $('[data-dialog]').live('focusin', function() {
      var target = $('#' + $(this).attr('data-dialog'));
      target.dialog({
        autoOpen: false,
        title: target.attr('data-dialog-title'),
        width: target.attr('data-dialog-width') || 740});
    });
    $('[data-dialog]').live('click', function(event) {
      console.info($(event.target).attr('data-dialog'));
      $('#' + $(event.target).attr('data-dialog')).dialog('open');
      return false;
    });

    $('[data-toggle]').live('click', function(event) {
      $('#' + $(event.target).attr('data-toggle')).toggle();
      return false;
    })

    $(':input[data-replace]').live('click', function(event) {
      var target = $(event.target);
      return replaceWith(
        target.attr('data-replace'),
        current_url() + '?' + target.serialize());
    });

    $('[data-replace] > a, a[data-replace]').live('click', function(event) {
      var target = $(event.target);
      target.trigger('update_selected');
      return replaceWith(target.closest('[data-replace]').attr('data-replace'), target.attr('href'));
    })

    $('form[data-replace]').live('submit', function(event){
      var source = $(event.target);
      return replaceWith(source.attr('data-replace'), source.attr('action') + '?' + source.serialize());
    });

    $('[data-district]').live('mouseover', function(event) {
      var self = $(event.target).closest('[data-district]');
      if (!self.data('init')) {
        self.data('init', true);
        var title = self.attr('data-district-title');
        self.qtip({
          content: {
            url: self.attr('data-district'),
            title: { text: title }
          },
          position: {
            corner: {
              target: 'bottomMiddle',
              tooltip: 'topMiddle'
            }
          },
          style: {
            border: {
              width: 5,
              radius: 5,
              color: '#8f8f8f'
            },
            tip: {
              corner: 'topMiddle',
              size: { x: 18, y: 18 }
            },
            width: 450,
            height: 285
          },
          show: {
            effect: { length: 200 }
          },
          api: {
            onShow: function () {
              self.data('needs_show', false);
              if (self.data('needs_refresh')) {
                self.qtip("api").loadContent(self.attr('data-district'));
                self.data('needs_refresh', false);
              }
            },
            beforeContentUpdate: function() {
              if (self.data('needs_show')) {
                self.data('needs_show', false);
                self.data('needs_refresh', true);
                return false;
              } else {
                self.data('needs_show', true);
              }
            }
          },
          hide: {
            fixed: true,
            delay: 500,
            effect: { length: 500 }
         }
        });
        self.mouseover();
      }
    });

    $('[data-qtip]').live('mouseover', function(event) {
      var self = $(event.target).closest('[data-qtip]');
      if (!self.data('init')) {
        self.data('init', true);
        var title = self.attr('data-qtip-title');
        self.qtip({
          content: {
            url: self.attr('data-qtip'),
            title: { text: title }
          },
          position: {
            corner: {
              target: 'bottomMiddle',
              tooltip: 'topMiddle'
            }
          },
          style: {
            border: {
              width: 5,
              radius: 5,
              color: '#8f8f8f'
            },
            tip: {
              corner: 'topMiddle',
              size: { x: 18, y: 18 }
            },
            width: 450
          },
          show: {
            effect: { length: 200 }
          },
          hide: {
            fixed: true,
            delay: 500,
            effect: { length: 500 }
         }
        });
        self.mouseover();
      }
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
})(jQuery);
