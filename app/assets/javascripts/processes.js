$(document).on('turbolinks:load', function() {

  var $draggable = $('.draggable');
  $draggable.each(function() {
    Sortable.create(this, {
      handle: ".input-group-addon"
    });
  });

  $('.js-add-step').click(function(e) {
    e.preventDefault();
    $draggable.append('' +
      '<div class="input-group mb-sm">' +
      '<label class="input-group-addon">' +
        '<i class="fa fa-bars fa-1x"></i>' +
      '</label>' +
      '<input type="text" name="church_process[steps][]" class="form-control" />' +
    '</div>');
  });
});
