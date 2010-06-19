(function($) {
  $(function(){
    $('[data-qtip-image]').live('mouseover mouseout', function(event) {
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
