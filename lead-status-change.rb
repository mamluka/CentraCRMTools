load 'init.rb'
load 'active_records_models.rb'

current_status = ARGV[0]
desired_status = ARGV[1]

leads_with_current_status = Lead.where(:status=> current_status)

puts "Found #{leads_with_current_status.length.to_s} leads with status #{current_status}"

if not desired_status.nil?
  leads_with_current_status.each do |lead|
    lead.status = desired_status
    lead.save
  end
end

puts "Moved #{leads_with_current_status.length.to_s} leads with status #{current_status} to status #{desired_status}"