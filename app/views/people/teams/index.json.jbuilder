json.array! @teams do |team|
  json.partial! 'people/teams/team', team: team
end
