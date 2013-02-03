load 'init.rb'
load 'active_records_models.rb'

logger = StandardLogger.get

clients = Lead.where('status = ? and', 'client')

infoless_clients = clients.select do |lead|
  !lead.custom_data.nil? && lead.custom_data.cancellation_change_date_c < 3.days.ago && lead.emails.any?
end

logger.info "Found #{infoless_clients.length.to_s} cancelled leads that are 3 days old and have email"

infoless_clients.each do |lead|

  email = lead.emails.first.email_address

  logger.info "#{lead.first_name} #{lead.last_name} will get an email to #{email}"

  mailer = ApiEmailer.new
  res = mailer.cancellation email

  if res=="OK"
    lead.custom_data.cancellation_email_sent_c = Time.now
    lead.save
  end

  sleep 20
end

logger.info "#{clients.length.to_s} cancelled leads got an email"