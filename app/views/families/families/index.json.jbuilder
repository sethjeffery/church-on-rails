json.array! @families do |family|
  json.partial! 'families/families/family', family: family
end
