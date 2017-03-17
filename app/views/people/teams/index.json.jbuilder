json.array! @teams do |team|
  json.extract! team, :id, :name, :icon, :color
  json.text team.name
  json.members team.people.pluck('first_name')
end
