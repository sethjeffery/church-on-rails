checkNavbarScroll = ->
  $('.navbar').toggleClass('navbar-short', $(window).scrollTop() > 100)

$(window).on 'resize scroll', checkNavbarScroll
$(document).on 'turbolinks:load scroll', checkNavbarScroll

$(document).on 'turbolinks:load', ->
  setTimeout (-> $('.navbar').addClass('navbar-transition')), 10

$(document).on 'click', '[data-toggle=drawer]', (e) ->
  e.preventDefault()
  $(@).toggleClass('active')
  $('.nav-material-tabs').toggleClass('open')
