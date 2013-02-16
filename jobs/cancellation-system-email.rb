require File.dirname(__FILE__) + '/lib/init.rb'
require File.dirname(__FILE__) + '/lib/active_records_models.rb'

logger = StandardLogger.get

cancelled_leads = Lead.where('status = ?', 'cancelled')

old_cancelled_leads = cancelled_leads.select do |lead|
  !lead.custom_data.nil? && lead.custom_data.cancellation_change_date_c < 3.days.ago && lead.emails.any? && !lead.do_not_email && lead.custom_data.cancellation_email_sent_c.nil?
end

logger.info "Found #{old_cancelled_leads.length.to_s} cancelled leads that are 3 days old and have email"

old_cancelled_leads.each do |lead|

  email = lead.emails.first.email_address

  logger.info "#{lead.first_name} #{lead.last_name} will get an email to #{email}"

  mailer = ApiEmailer.new
  res = mailer.cancellation email

  if res=="OK"
    lead.custom_data.cancellation_email_sent_c = Time.now
    lead.save
  else
    logger.info "Api returned error response: " + res
  end

  sleep 20
end

logger.info "#{old_cancelled_leads.length.to_s} cancelled leads got an email"
