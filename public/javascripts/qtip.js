;(function($) {
  $(document).ready(function(){
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
              if (self.data('needs_refresh')) {
                self.qtip("api").loadContent(self.attr('data-district'));
                self.removeData('needs_refresh');
              }
              self.data('last', 'show');
            },
            beforeHide: function () {
              if (self.data('needs_load')) {
                return false;
              }
              self.data('last', 'hide');
            },
            beforeContentUpdate: function() {
              if (self.data('last') == 'update') {
                self.data('needs_refresh', true);
                return false;
              } else if (self.data('last') == undefined) {
                self.data('needs_load', true);
              } else {
                self.removeData('needs_load');
              }
              self.data('last', 'update');
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

    $('[data-qtip-path]').live('mouseover', function(event) {
      var self = $(event.target).closest('[data-qtip-path]');
      if (!self.data('init')) {
        self.data('init', true);
        var title = self.attr('data-qtip-title');
        self.qtip({
          content: {
            url: self.attr('data-qtip-path'),
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

    $('[data-qtip-image]').live('mouseover', function(event) {
      var self = $(event.target).closest('[data-qtip-image]');
      if (!self.data('init')) {
        self.data('init', true);
        var title = self.attr('alt');
        var width = self.attr('data-qtip-width');
        self.qtip({
          content: {
            text: '<img src="' + self.attr('data-qtip-image') + '" alt="' + title + '" width="' + width + '" />',
            title: { text: title }
          },
          position: {
            corner: {
              target: 'bottomMiddle',
              tooltip: 'topMiddle'
            }
          },
          style: {
            'text-align': 'center',
            width: parseInt(width, 10) + 30,
            border: {
              width: 5,
              radius: 5,
              color: '#8f8f8f'
            },
            tip: {
              corner: 'topMiddle',
              size: { x: 18, y: 18 }
            },
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
  });
})(jQuery);
