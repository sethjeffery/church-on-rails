$(document).on 'turbolinks:load', ->
  $('#import_has_header').change (e) ->
    $('#table-row-1').toggleClass('table-row-disabled', $(@).prop('checked'))
