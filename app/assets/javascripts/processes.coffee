$(document).on 'turbolinks:load', ->
  $draggable = $('.draggable')
  Sortable.create draggable, handle: '.input-group-addon' for draggable in $draggable

  $('.js-add-step').click (e) ->
    e.preventDefault()
    $draggable.append """
      <div class="input-group mb-sm">
        <label class="input-group-addon">
          <i class="fa fa-bars fa-1x"></i>
        </label>
        <input type="text" name="church_process[steps][]" class="form-control" />
      </div>
    """
