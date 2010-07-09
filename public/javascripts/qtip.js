(function($) {
  $(function(){
    $('.act-qtip-image').live('mouseover', function(event) {
      var self = $(event.target).closest('.act-qtip-image');
      if (!self.data('init')) {
        self.data('init', true);
        var title = self.attr('alt');
        var width = self.attr('class').split(' ').map(function(e) {
          return e.split('qtip-width-')[1];
        }).filter(function (e) {
          return (typeof(e) != 'undefined')
        })[0];
        self.qtip({
          content: {
            text: '<img src="' + self.attr('rel') + '" alt="' + title + '" width="' + width + '" />',
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
