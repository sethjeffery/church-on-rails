json.array! @families do |family|
  json.extract! family, :id, :name
  json.text family.name
end
