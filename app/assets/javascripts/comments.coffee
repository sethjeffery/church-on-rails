$(document).on 'turbolinks:load', ->

  $('textarea#comment_description').keydown (e) ->
    if e.which == 13 and !e.shiftKey
      $(this).closest('form').submit()
      e.preventDefault()
