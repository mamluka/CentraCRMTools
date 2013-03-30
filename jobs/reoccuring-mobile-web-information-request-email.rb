require_relative "lib/jobs-base"
require_relative "../emails/mailer_base"

class ResendMobileWebCustomerDataRequestJob < JobsBase

  def execute
    leads = CustomData.where('host_login_c is null and mobileweb_check_c = 1').select { |x| !x.do_not_email }.map { |x| x.lead }.select { |x| x.status =="client" && x.emails.any? }
    logger.info "Found #{leads.length.to_s} mobile web clients that did not enter their data"

    leads.each do |lead|
      email = lead.email
      logger.info "#{lead.name} will get an email to #{email}"

      begin
        MobileWebEmails.mobile_web_details_request(email, lead.name, lead.id).deliver

        lead.custom_data.mobileweb_info_req_sent_c = Time.now
        lead.save

        Note.add lead.id, "Sent a mobile web hosting provider details request"
      rescue => ex
        logger.info "Email returned error response: " + ex.message
      end

      sleep 5
    end

    logger.info "#{leads.length.to_s} mobile web clients got a request data reminder"
  end
end

job = ResendMobileWebCustomerDataRequestJob.new
job.execute