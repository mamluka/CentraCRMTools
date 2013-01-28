load 'init.rb'
load 'active_records_models.rb'

current_status = ARGV[0]
desired_status = ARGV[1]

leads_with_current_status = Lead.find(:status=> current_status)

puts "Found #{leads_with_current_status.length.to_s} leads with status #{current_status}"