$(document).on('turbolinks:load', function() {
  $('[data-tooltip]').tooltip();
});


$(document).on('turbolinks:visit', function() {
  $('[data-tooltip]').tooltip('dispose');
});
