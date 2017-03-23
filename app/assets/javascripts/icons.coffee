window.iconNameFor = (resource) ->
  switch resource.toLowerCase()
    # models
    when 'account' then 'user-circle-o'
    when 'church' then 'home'
    when 'person' then 'user'
    when 'team'  then 'users'
    when 'family' then 'address-card'
    when 'church_process' then 'ellipsis-h'
    when 'person_process' then 'flag'
    when 'event' then 'calendar-check-o'
    when 'child_group' then 'child'
    when 'child_group_membership' then 'user-plus'
    when 'comment' then 'comment'
    when 'property' then 'toggle-on'
    when 'child' then 'child'

    # other common nouns
    when 'x' then 'times'
    when 'facebook' then 'facebook-square'
    when 'twitter' then 'twitter-square'
    when 'process' then 'ellipsis-h'
    when 'email' then 'envelope'
    when 'password' then 'lock'
    when 'edit' then 'pencil'
    when 'merge' then 'handshake-o'
    when 'new' then 'plus'
    when 'index' then 'search'
    when 'destroy' then 'times'

    # treat anything left as a FontAwesome icon name
    else resource.toLowerCase().replace(/_/, '-')
