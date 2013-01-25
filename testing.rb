load 'init.rb'
load 'active_records_models.rb'

lead = Lead.find('499eab2d-e0df-b699-17da-50fdebe2d35d')

puts lead.id
puts lead.leads_custom_data.company_name_c
puts lead.email_address_relation.email_address_id