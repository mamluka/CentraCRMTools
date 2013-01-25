load 'init.rb'
load 'active_records_models.rb'

lead = Lead.last

puts lead.id
puts lead.leads_custom_data.company_name_c
puts lead.email_addresss.first.email_address