json.array! @people do |person|
  json.partial! 'people/people/person', person: person
end
