require_relative '../lib/jobs-base'
require_relative '../../emails/mailer_base'

class ResendMobileWebCustomerDataRequestJob < JobsBase

  def execute
    leads = CustomData.where('host_login_c is null and mobileweb_check_c = 1 and mobileweb_sale_date_c < ?', 7.days.ago).select { |x| !x.do_not_email }.map { |x| x.lead }.select { |x| x.status =="client" && x.emails.any? }
    logger.info "Found #{leads.length.to_s} mobile web clients that did not enter their data for a whole week"

    leads.each do |lead|

      begin

        AnnouncementsEmails.remind_to_call_client_after_a_week_if_no_hosting_details(lead.id).deliver
        Note.add lead.id, "A reminder was send to call collect hosting provider details, because they are still missing after a week"

        sleep wait_between_emails_interval
      rescue => ex
        logger.info "Emailing failed with message: " + ex.message
      end
    end

    logger.info "#{leads.length.to_s} mobile web clients got a request data reminder"
  end
end

job = ResendMobileWebCustomerDataRequestJob.new
job.execute