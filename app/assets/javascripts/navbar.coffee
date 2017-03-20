checkNavbarScroll = ->
  scrolled = $(window).scrollTop() > 60
  $el = $('.navbar > .nav-material-tabs.fixed-top')
  $el = $('.navbar > .nav-material-tabs').clone().addClass('fixed-top').appendTo($('.navbar')) unless $el.length
  $el.toggleClass('hidden-xs-up', !scrolled)

$(window).on 'resize scroll', checkNavbarScroll
$(document).on 'turbolinks:load scroll', checkNavbarScroll

$(document).on 'turbolinks:before-cache', ->
  $('.navbar').removeClass('navbar-short')

$(document).on 'click', '[data-toggle=drawer]', (e) ->
  e.preventDefault()
  $(@).toggleClass('active')
  $('.nav-material-tabs').toggleClass('open')
