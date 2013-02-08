load File.dirname(__FILE__) + '/lib/init.rb'
load File.dirname(__FILE__) + '/lib/active_records_models.rb'

logger = StandardLogger.get

clients = Lead.where('status = ?', 'client')

clients_without_local_listing_data = clients.select do |lead|
  !lead.custom_data.nil? && !lead.custom_data.googlelocal_info_req_sent_c.nil? && lead.custom_data.googlelocal_info_req_sent_c < 3.days.ago && lead.emails.any? && lead.primary_address_street.nil? && lead.primary_address_postalcode.nil?
end

logger.info "Found #{clients_without_local_listing_data.length.to_s} local listing clients tha did not filled the details form and 3 days had passed"

clients_without_local_listing_data.each do |lead|

  email = lead.emails.first.email_address

  logger.info "#{lead.first_name} #{lead.last_name} will get local listing details request an email to #{email}"

  mailer = ApiEmailer.new
  res = mailer.googlelocal_info_request email, lead.first_name, lead.id

  if res=="OK"
    lead.custom_data.googlelocal_info_req_sent_c = Time.now
    lead.save
  else
    logger.info "Api returned error response: " + res
  end

  sleep 20
end

logger.info "#{clients_without_local_listing_data.length.to_s} leads got a reoccurring local listing details request"