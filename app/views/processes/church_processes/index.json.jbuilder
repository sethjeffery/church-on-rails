json.array! @church_processes do |church_process|
  json.extract! church_process, :id, :name, :icon
  json.text church_process.name
end
