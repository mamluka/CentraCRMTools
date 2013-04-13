require 'json'

config_file = File.dirname(__FILE__) +'/jobs/active.json'

config_file_exists = File.exists?(config_file)
if config_file_exists
  jobs_profile = JSON.parse(File.read(config_file))
end

Dir[File.dirname(__FILE__) + '/jobs/*.rb'].each do |file|

  if config_file_exists
    load file if jobs_profile.any? { |k, v| file.include?(k) && v == 'enable' }
  else
    load file
  end

end