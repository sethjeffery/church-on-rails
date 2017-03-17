json.array! @people do |person|
  json.extract! person, :id, :name, :icon, :email, :age
  json.text person.name
end
