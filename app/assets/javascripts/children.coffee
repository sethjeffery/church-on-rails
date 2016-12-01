$(document).on 'turbolinks:load', ->
  $personId = $('#child_group_membership_person_id')
  $newChildForm = $('#child_group_membership_new_child')
  $familyName = $('#child_group_membership_person_family_name')
  $familyIds = $('#child_group_membership_person_family_ids')
  $lastName = $('#child_group_membership_person_last_name')

  $newChildForm.hide().find('[required]').prop(required: false).attr("data-required": true)
  $familyName.hide()

  $personId.change ->
    value = $(this).val()
    if value == 'New'
      $newChildForm.show().find('[data-required]').prop(required: true).attr("data-required": null)
    else
      $newChildForm.hide().find('[required]').prop(required: false).attr("data-required": true)

  $familyIds.change ->
    value = $(this).val()
    if value == 'New'
      $familyName.show().val $lastName.val()
    else
      $familyName.hide().val ''
