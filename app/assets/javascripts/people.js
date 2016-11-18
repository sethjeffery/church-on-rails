$(document).on('turbolinks:load', function() {
  var $familyName = $('#person_family_name'),
    $familyIds    = $('#person_family_ids'),
    $lastName     = $('#person_last_name');

  $familyName.hide();

  $familyIds.change(function(e) {
    var value = $(this).val();

    if (!value) {
      $familyName.hide().val('');

    } else if (value == 'New') {
      $familyName.show().val($lastName.val());

    } else {
      $familyName.hide().val('');

    }
  });
});
