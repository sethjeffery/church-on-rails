$(document).on 'turbolinks:load', ->
  $('[data-tooltip]').tooltip()

$(document).on 'turbolinks:visit', ->
  $('[data-tooltip]').tooltip 'dispose'
