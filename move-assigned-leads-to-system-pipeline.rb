load 'init.rb'
load 'active_records_models.rb'

logger = StandardLogger.get

week_old_leads = Lead.where('date_entered < ? and status= ?', 7.day.ago, 'FU')

logger.info "We have found #{week_old_leads.length.to_s} leads"

week_old_leads.each do |lead|
  lead.status = 'SP'
  lead.assigned_user_id = $system_pipeline_user_id

  if lead.custom_data.prev_url_c != "http://" && lead.emails.any? && lead.custom_data.system_pipeline_email_1_c.nil? && lead.is_emailable?
    logger.info "loaded custom data for #{lead.first_name} the data has in it #{lead.custom_data.prev_url_c}"

    email = lead.emails.first.email_address

    logger.info "it has the email: #{email}"

    mailer = ApiEmailer.new

    mailer.first_system_pipeline email, lead.custom_data.prev_url_c

    logger.info "The api call response: #{res}"

    if res == "OK"
      lead.custom_data.system_pipeline_email_1_c = Time.now
    end

  end

  lead.save

  logger.info "--Done--"
  sleep 10
end

logger.info "we have modified and sent to:  #{week_old_leads.length.to_s} leads"

