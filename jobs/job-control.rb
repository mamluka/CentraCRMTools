require 'json'

config_file = File.dirname(__FILE__) +'/jobs/active.json'

config_file_exists = File.exists?(config_file)
if config_file_exists
  already_enabled_jobs = JSON.parse(File.read(config_file))
end

who = ARGV[0]
action = ARGV[1]

if who == "list"

  if not config_file_exists
    puts 'No file to list'
    Kernel.exit 1
  end

  already_enabled_jobs.each { |k, v| puts "#{k} is set to: #{v}" }
  Kernel.exit 0
end

if action != 'enable' && action != 'disable'
  puts 'Please select action to be enable/disable'
  Kernel.exit 1
end


if who == 'all'
  enabled_jobs = Hash[Dir[File.dirname(__FILE__) + '/jobs/*.rb'].map { |v| [v.match(/\/jobs\/(.+?)\.rb/)[1], action] }]
else
  enabled_jobs = {who => action}
end

File.open(config_file, 'w') { |file| file.write(JSON.pretty_generate(already_enabled_jobs.merge(enabled_jobs))) }

