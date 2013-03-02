require_relative "lib/jobs-base"

class CancellationEmailJob < JobsBase

  def execute
    leads = CustomData.where('cancellation_change_date_c < ?', 3.days.ago).select { |x| !x.do_not_email && x.cancellation_email_sent_c.nil? }.map { |x| x.lead }.select { |x| x.status =="cancelled" && x.emails.any? }
    logger.info "Found #{leads.length.to_s} cancelled leads that are 3 days old and have email"

    leads.each do |lead|
      email = lead.email
      logger.info "#{lead.name} will get an cancellation email to #{email}"

      res = mailer.cancellation email

      if res=="OK"
        lead.custom_data.cancellation_email_sent_c = Time.now
        lead.save

        sleep 5
      else
        logger.info "Api returned error response: " + res
      end
    end

    logger.info "#{leads.length.to_s} cancelled leads got an email"
  end
end

job = CancellationEmailJob.new
job.execute

