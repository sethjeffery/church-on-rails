$(document).on 'turbolinks:load', ->

  $alert = $('.alert-floating')
  if $alert.length > 0
    setTimeout ( -> $alert.addClass('in')    ), 200
    setTimeout ( -> $alert.removeClass('in') ), 3000
    setTimeout ( -> $alert.remove()          ), 3300
