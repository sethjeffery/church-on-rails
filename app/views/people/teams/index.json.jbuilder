json.array! @teams do |team|
  json.extract! team, :id, :name, :icon, :color
  json.text team.name
end
