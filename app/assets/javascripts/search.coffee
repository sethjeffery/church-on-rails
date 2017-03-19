$(document).on 'shown.bs.modal', '#search-modal', ->
  $('#search-modal input').focus().select()

showLoader = ->
  $('.search-modal-results').html("<div class='loader'><i></i><i></i><i></i><i></i><i></i><i></i><i></i><i></i></div>")

searchXhr = null
searchQuery = null
$(document).on 'keyup change paste', '#search-modal input', ->
  q = $(@).val()

  # Don't call more than we need to
  return if searchQuery == q
  searchQuery = q

  # Show a pretty ajax spinner
  showLoader() unless $('.search-modal-results .loader').length

  # Abort any current AJAX calls and then query the server for search results
  searchXhr?.abort()
  searchXhr = $.getJSON Routes.search_path(), { q }, (data) ->

    # Render each search result using the search_result template
    html = ""
    for item in data
      item.icon = iconNameFor(item.icon or item.type)
      item.category = item.type[0].toUpperCase() + item.type[1..-1]

      switch item.type
        when 'person'
          item.href = Routes.person_path(item.id)
          item.subtitle = item.email
        when 'family'
          item.href = Routes.family_path(item.id)
          item.subtitle = item.members?.join(', ')
        when 'team'
          item.href = Routes.team_path(item.id)
          item.subtitle = item.members?.join(', ')

      html += HandlebarsTemplates.search_result(item)

    # Replace search results with built HTML
    $('.search-modal-results').html(html)

# When pressing enter, click the first link
$(document).on 'keydown', '#search-modal input', (e) ->
  if e.which == 13
    e.preventDefault()
    Turbolinks.visit $('.search-modal-results > a:first').attr('href')

# Make sure that modal disappears when we move between turbolinks pages
$(document).on 'turbolinks:before-visit', ->
  $('#search-modal').modal('hide')

$(document).on 'turbolinks:render', ->
  $('#search-modal').modal('hide')
  $('.modal-backdrop').remove()
