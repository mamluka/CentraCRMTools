require_relative '../lib/jobs-base'
require_relative '../../emails/mailer_base'

class ReportReminderJob < JobsBase

  def execute
    leads = CustomData.where('googlelocal_sign_date_c < ? and googlelocal_report_sent_date_c is NULL', 21.days.ago).select { |x| !x.do_not_email }.map { |x| x.lead }.select { |x| x.status =="client" && x.emails.any? }
    logger.info "Found #{leads.length.to_s} clients that signed the contract 3 weeks ago and did not get a report"

    leads.each do |lead|
      logger.info "#{lead.name} will be sending a reminder"

      begin
        AnnouncementsEmails.remind_to_generate_a_report(lead.id).deliver
        Note.add lead.id, "Sent a reminder for generating a progress report for the client"

        sleep wait_between_emails_interval
      rescue => ex
        logger.info "Email sending returned error response: " + ex.message
      end
    end

    logger.info "#{leads.length.to_s} reminders were sent"
  end
end

job = ReportReminderJob.new
job.execute
