require_relative "lib/jobs-base"
require_relative "../emails/status"

class CancellationEmailJob < JobsBase

  def execute
    leads = CustomData.where('cancellation_change_date_c < ?', 3.days.ago).select { |x| !x.do_not_email && x.cancellation_email_sent_c.nil? }.map { |x| x.lead }.select { |x| x.status =="cancelled" && x.emails.any? }
    logger.info "Found #{leads.length.to_s} cancelled leads that are 3 days old and have email"

    leads.each do |lead|
      email = lead.email
      logger.info "#{lead.name} will get an cancellation email to #{email}"

      begin

        StatusEmails.cancellation(email).deliver
        lead.custom_data.cancellation_email_sent_c = Time.now
        lead.save

        Note.add lead.id, "Cancellation email was sent 3 days after status was set to cancelled"

        sleep 5
      rescue => ex
        logger.info "Email sending returned error response: " + ex.message
      end
    end

    logger.info "#{leads.length.to_s} cancelled leads got an email"
  end
end

job = CancellationEmailJob.new
job.execute

