$(document).on('turbolinks:load', function() {
  var $icon = $('#team_icon'), $color = $('#team_color')

  $('[data-toggle=color]').click(function(e) {
    e.preventDefault();
    var color = $(this).data('color');
    $color.val(color);
    $(this).parents('.input-group-btn').find('> a').css({ color: '#' + color });
  });

  $('[data-toggle=icon]').click(function(e) {
    e.preventDefault();
    var icon = $(this).data('icon');
    $icon.val(icon);
    $(this).parents('.input-group-btn').find('> a .fa').removeClass().addClass("fa fa-" + icon + " fa-1x");
  });

});
