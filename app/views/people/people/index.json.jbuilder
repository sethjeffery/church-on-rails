json.array! @people do |person|
  json.extract! person, :id, :name, :icon
  json.text person.name
end
