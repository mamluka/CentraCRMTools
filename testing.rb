load 'init.rb'
load 'active_records_models.rb'

leads = Lead.where('status = ? and date_entered < ?', 'SP', 7.days.ago)

leads_that_did_not_send = leads.select do |lead|
  lead.custom_data.system_pipeline_email_1_c.nil? && lead.custom_data.prev_url_c != 'http://'
end

leads_that_did_not_send.each do |lead|
  puts lead.id
  puts lead.custom_data.prev_url_c
  puts lead.custom_data.mobile_preview_email_sent_c.to_s
end



