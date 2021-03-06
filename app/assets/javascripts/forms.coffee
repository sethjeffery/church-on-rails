$(document).on 'turbolinks:load', ->

  pickerIcons =
    time: 'fa fa-clock-o fa-1x'
    date: 'fa fa-calendar fa-1x'
    up: 'fa fa-arrow-up fa-1x'
    down: 'fa fa-arrow-down fa-1x'
    previous: 'fa fa-chevron-left fa-1x'
    next: 'fa fa-chevron-right fa-1x'
    today: 'fa fa-circle fa-1x'
    clear: 'fa fa-trash fa-1x'
    close: 'fa fa-times fa-1x'

  pickerOptions = ($el) ->
    icons: pickerIcons
    format: $el.data('format') or 'DD MMM YYYY HH:mm'
    viewMode: $el.data('view-mode')
    showClear: $el.data('show-clear')
    showClose: $el.data('show-close')

  # Lovely date pickers with <input data-datetimepicker />
  $('[data-datetimepicker]').each ->
    $(@).datetimepicker pickerOptions($(@))

  # Auto-size all text areas
  $('textarea').autosize()

  # Color pickers
  $('[data-toggle=color]').click (e) ->
    e.preventDefault()
    color = $(@).data('color')
    $el.parents('form').find("input[name*='[icon]']").val color
    $(@).parents('.input-group-btn').find('> a').css(color: '#' + color)

  # Icon pickers
  $('[data-toggle=icon]').click (e) ->
    e.preventDefault()
    $el = $(@)
    icon = $el.data('icon')
    $el.parents('form').find("input[name*='[icon]']").val $el.data('value') or icon
    $el.parents('.input-group-btn').find('> a .fa').removeClass().addClass('fa fa-' + icon + ' fa-1x')

  $('input[type=file]').change (e) ->
    $el = $(@)
    file = @files[0]

    if file
      $el.next('.custom-file-control').attr('data-placeholder', file.name)
    else
      $el.next('.custom-file-control').removeAttr('data-placeholder')

    if $el.data('auto-submit')
      $el.closest('form').submit()
      $el.prop(disabled: true)
