$(document).on('turbolinks:load', function() {

  var pickerIcons = {
    time: 'fa fa-clock-o fa-1x',
    date: 'fa fa-calendar fa-1x',
    up: 'fa fa-arrow-up fa-1x',
    down: 'fa fa-arrow-down fa-1x',
    previous: 'fa fa-chevron-left fa-1x',
    next: 'fa fa-chevron-right fa-1x',
    today: 'fa fa-circle fa-1x',
    clear: 'fa fa-trash fa-1x',
    close: 'fa fa-times fa-1x'
  };

  var pickerOptions = function($el) {
    return {
      icons: pickerIcons,
      format: $el.data('format') || 'DD MMM YYYY HH:mm',
      viewMode: $el.data('view-mode'),
      showClear: $el.data('show-clear'),
      showClose: $el.data('show-close')
    };
  };

  $('[data-datetimepicker]').each(function() {
    $(this).datetimepicker(pickerOptions($(this)));
  });

  $('[data-selectpicker]').select2({ theme: 'bootstrap' });

  $('textarea#comment_description').autosize().keydown(function(e) {
    if (e.which == 13 && !e.shiftKey) {
      $(this).closest('form').submit();
      e.preventDefault();
    }
  });
});
