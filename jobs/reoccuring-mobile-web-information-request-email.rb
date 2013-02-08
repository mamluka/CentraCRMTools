load File.dirname(__FILE__) + '/lib/init.rb'
load File.dirname(__FILE__) + '/lib/active_records_models.rb'

logger = StandardLogger.get

clients = Lead.where('status = ?', 'client')

clients_without_hosting_provider_data = clients.select do |lead|
  !lead.custom_data.nil? && !lead.custom_data.mobileweb_info_req_sent_c.nil? && lead.custom_data.mobileweb_info_req_sent_c < 3.days.ago && lead.emails.any? && lead.custom_data.host_login_c.nil?
end

logger.info "Found #{clients_without_hosting_provider_data.length.to_s} mobile web clients tha did not filled the details form and 3 days had passed"

clients_without_hosting_provider_data.each do |lead|

  email = lead.emails.first.email_address

  logger.info "#{lead.first_name} #{lead.last_name} will get mobile web details request an email to #{email}"

  mailer = ApiEmailer.new
  res = mailer.mobileweb_info_request email, lead.first_name, lead.id

  if res=="OK"
    lead.custom_data.mobileweb_info_req_sent_c = Time.now
    lead.save
  else
    logger.info "Api returned error response: " + res
  end

  sleep 20
end

logger.info "#{clients_without_hosting_provider_data.length.to_s} leads got a reoccurring mobile details request"