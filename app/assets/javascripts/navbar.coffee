checkNavbarScroll = ->
  $('.navbar').toggleClass('navbar-short', $(window).scrollTop() > 76)

$(window).on 'resize scroll', checkNavbarScroll
$(document).on 'turbolinks:load scroll', checkNavbarScroll

$(document).on 'turbolinks:before-cache', ->
  $('.navbar').removeClass('navbar-short')

$(document).on 'click', '[data-toggle=drawer]', (e) ->
  e.preventDefault()
  $(@).toggleClass('active')
  $('.nav-material-tabs').toggleClass('open')
