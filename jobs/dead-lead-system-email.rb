load File.dirname(__FILE__) + '/lib/init.rb'
load File.dirname(__FILE__) + '/lib/active_records_models.rb'

logger = StandardLogger.get

dead_leads = Lead.where('status = ? and assigned_user_id = ?', 'Dead', $system_pipeline_user_id)

old_dead_leads = dead_leads.select do |lead|
  !lead.custom_data.nil? && !lead.custom_data.dead_status_assigned_date_c.nil? && lead.custom_data.dead_status_assigned_date_c < 7.days.ago && lead.emails.any? && !lead.do_not_email && lead.custom_data.dead_client_email_sent_c.nil? && lead.custom_data.not_billable_c.nil == true
end

logger.info "Found #{old_dead_leads.length.to_s} dead leads that are 7 days old and did not got a dead client email"

old_dead_leads.each do |lead|

  email = lead.emails.first.email_address

  logger.info "#{lead.first_name} #{lead.last_name} will get an email to #{email}"

  mailer = ApiEmailer.new
  res = mailer.dead_client email

  if res=="OK"
    lead.custom_data.dead_client_email_sent_c = Time.now
    lead.save
  else
    logger.info "Api returned error response: " + res
  end

  sleep 20
end

logger.info "#{old_dead_leads.length.to_s} dead leads got an dead user email"
