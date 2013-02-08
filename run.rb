Dir[File.dirname(__FILE__) + '/jobs/*.rb'].each do |file|
  load file
end