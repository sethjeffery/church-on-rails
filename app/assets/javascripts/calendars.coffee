toggleTeams = ->
  $parent = $(@).parents('.list-group-item')
  $parent.find('.teams-list').toggleClass('hidden-xs-up', !$parent.find('input[name*=visibility][value=teams]').is(':checked'))

$(document).on 'change', '.edit_calendar_settings input[name*=visibility]', toggleTeams

$(document).on 'turbolinks:load', ->
  $('.edit_calendar_settings input[name*=visibility]').each(toggleTeams)
