load File.dirname(__FILE__) + '/lib/init.rb'
load File.dirname(__FILE__) + '/lib/active_records_models.rb'

logger = StandardLogger.get

system_leads = Lead.where('status = ? and assigned_user_id = ?', 'SP', $system_pipeline_user_id)

two_weeks_old_system_leads = system_leads.select do |lead|
  !lead.custom_data.nil? && !lead.custom_data.system_pipeline_email_1_c.nil? && lead.custom_data.system_pipeline_email_1_c < 7.days.ago && lead.emails.any? && !lead.do_not_email && lead.custom_data.system_pipeline_email_2_c.nil?
end

logger.info "Found #{two_weeks_old_system_leads.length.to_s} system leads that have received the first system pipline email 7 days ago"

two_weeks_old_system_leads.each do |lead|

  if lead.custom_data.prev_url_c.nil?
    next
  end

  email = lead.emails.first.email_address

  logger.info "#{lead.name} will get an system pipeline email #2 to #{email}"

  mailer = ApiEmailer.new
  res = mailer.second_system_pipeline email, lead.custom_data.prev_url_c

  if res=="OK"
    lead.custom_data.system_pipeline_email_2_c = Time.now
    lead.save
  else
    logger.info "Api returned an error " + res
  end

  sleep 20
end

logger.info "#{two_weeks_old_system_leads.length.to_s} system leads got the second email"