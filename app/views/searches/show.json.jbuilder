json.array! @search.items do |item|
  json.type item.class.name.underscore

  if item.class == Person
    json.partial! 'people/people/person', person: item

  elsif item.class == Family
    json.partial! 'families/families/family', family: item

  elsif item.class == Team
    json.partial! 'people/teams/team', team: item
  end
end
