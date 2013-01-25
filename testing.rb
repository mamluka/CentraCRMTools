load 'init.rb'
load 'active_records_models.rb'

lead = Lead.first

puts lead.id
puts lead.leads_custom_data.company_name_c