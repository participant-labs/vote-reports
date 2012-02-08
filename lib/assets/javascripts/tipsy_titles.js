//= require jquery.tipsy

$(function() {
  $('[title]').live('mouseover', function() {
    var self = $(this);
    if (!self.data('tipsy-init')) {
      self.data('tipsy-init', true);
      self.tipsy({fade: true, gravity: 'n'});
      self.mouseover();
    }
  });
});
