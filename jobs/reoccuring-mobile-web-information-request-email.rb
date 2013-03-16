require_relative "lib/jobs-base"

class ResendMobileWebCustomerDataRequestJob < JobsBase

  def execute
    leads = CustomData.where('host_login_c is null and mobileweb_check_c = 1').select { |x| !x.do_not_email }.map { |x| x.lead }.select { |x| x.status =="client" && x.emails.any? }
    logger.info "Found #{leads.length.to_s} mobile web clients that did not enter their data"

    leads.each do |lead|
      email = lead.email
      logger.info "#{lead.name} will get an email to #{email}"

      res = mailer.mobileweb_info_request email, lead.first_name, lead.id

      if res=="OK"
        lead.custom_data.mobileweb_info_req_sent_c = Time.now
        lead.save

        Note.add lead.id, "Sent a mobile web hosting provider details request"
      else
        logger.info "Api returned error response: " + res
      end

      sleep 5
    end

    logger.info "#{leads.length.to_s} mobile web clients got a request data reminder"
  end
end

job = ResendMobileWebCustomerDataRequestJob.new
job.execute