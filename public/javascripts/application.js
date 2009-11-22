// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
// 
// $.fn.fadeOutSoon = function(when, length) {
//   if (typeof when == "undefined") when = 5000;
//   if (typeof length == "undefined") length = 1000;
//   var $this = $(this);
//   setTimeout(function() {
//     $this.fadeOut(length)
//   }, when);
//   return $this;
// };
;(function($) {
  $.fn.fadeOutSoon = function(when, length) {
    if (typeof when == "undefined") when = 5000;
    if (typeof length == "undefined") length = 1000;
    var $this = $(this);
    setTimeout(function() {
      $this.fadeOut(length)
    }, when);
    return $this;
  };
  
  $(document).ready(function(){

    $('.flash').fadeOutSoon(1000);


  });
})(jQuery);


