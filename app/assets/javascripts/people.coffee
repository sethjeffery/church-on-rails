$(document).on 'turbolinks:load', ->
  $familyName = $('#person_family_name')
  $familyIds = $('#person_family_ids')
  $lastName = $('#person_last_name')
  $prefix = $('#person_prefix')
  $gender = $('#person_gender')

  $familyName.hide()

  $familyIds.change ->
    value = $(this).val()
    if value == 'New'
      $familyName.show().val $lastName.val()
    else
      $familyName.hide().val ''

  $prefix.change ->
    unless $gender.val()
      gender = switch $(@).val()
        when 'Mr', 'Sir'         then 'm'
        when 'Mrs', 'Ms', 'Miss' then 'f'
        else null
      $gender.val(gender).trigger('change.select2') # update select2 UI
