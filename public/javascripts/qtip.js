;(function($) {
  $(document).ready(function(){
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
            effect: { length: 200 },
            delay: self.attr('data-qtip-delay') || 140
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
