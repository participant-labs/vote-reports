;(function($) {
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
      if (typeof(init_map) != 'undefined' && $.isFunction(init_map)) {
        init_map();
      }
    });
    return false;
  }

  $(function(){
    $(':input.act-replace').live('click', function(event) {
      var target = $(event.target);
      replaceWith(
        target.attr('rel'),
        current_url() + '?' + target.closest('form').serialize());
      return true;
    });

    $('.act-replace > a, a.act-replace').live('click', function(event) {
      var target = $(event.target);
      target.trigger('update_selected');
      return replaceWith(target.closest('.act-replace').attr('rel'), target.attr('href'));
    })

    $('form.act-replace').live('submit', function(event){
      var source = $(event.target);
      return replaceWith(source.attr('rel'), source.attr('action') + '?' + source.serialize());
    });
  });
})(jQuery);
