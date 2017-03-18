json.extract! family, :id, :name
json.text family.name
json.members family.people.pluck('first_name')
