load 'init.rb'
load 'active_records_models.rb'

logger = StandardLogger.get

system_leads = Lead.where('status = ? and assigned_user_id = ?', 'SP', $system_pipeline_user_id)

two_weeks_old_system_leads = system_leads.select do |lead|
  !lead.custom_data.nil? && !lead.custom_data.system_pipeline_email_1_c.nil? && lead.custom_data.system_pipeline_email_1_c < 7.days.ago && lead.emails.any? && lead.is_emailable?
end

logger.info "Found #{two_weeks_old_system_leads.length.to_s} system leads that have recieved the first system pipline email 7 days ago"

two_weeks_old_system_leads.each do |lead|

  email = lead.emails.first.email_address

  logger.info "#{lead.name} will get an system pipeline email #2 to #{email}"

  mailer = ApiEmailer.new
  res = mailer.second_system_pipeline email, lead.custom_data.prev_url_c

  if res=="OK"
    lead.custom_data.system_pipeline_email_2_c = Time.now
    lead.save
  end

  sleep 20
end

logger.info "#{system_leads.length.to_s} system leads got the second email"