require_relative "lib/jobs-base"

class JobCancellationEmail < JobsBase
  def execute
    leads = CustomData.where(:cancellation_change_date_c < 3.days.ago).select { |x| !x.do_not email && x.cancellation_email_sent_c.nil? }.map { |x| x.lead }.select { |x| x.status =="cancelled" && x.emails.any? }
    @logger.info "Found #{leads.length.to_s} cancelled leads that are 3 days old and have email"

    leads.each do |lead|
      email = lead.email
      logger.info "#{lead.name} will get an cancellation email to #{email}"

      result = @mailer.cancellation email

      if res=="OK"
        lead.custom_data.cancellation_email_sent_c = Time.now
        lead.save

        sleep 20
      else
        logger.info "Api returned error response: " + res
      end

    end

    logger.info "#{old_cancelled_leads.length.to_s} cancelled leads got an email"
  end
end

job = JobCancellationEmail.new
job.execute

