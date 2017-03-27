toggleRecipients = ->
  $('.new_message input[name*=send_to]').each ->
    $($(@).data('toggle')).toggleClass('hidden-xs-up', !$(@).is(':checked'))

$(document).on 'change', '.new_message input[name*=send_to]', toggleRecipients
$(document).on 'turbolinks:load', toggleRecipients
