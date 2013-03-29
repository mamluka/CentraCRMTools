require_relative "lib/jobs-base"
require_relative "../emails/status"

class DeadEmailJob < JobsBase

  def execute
    leads = CustomData.where('dead_status_assigned_date_c < ?', 7.days.ago).select { |x| !x.do_not_email && x.dead_client_email_sent_c.nil? && !x.not_billable_c }.map { |x| x.lead }.select { |x| x.status =="Dead" && x.emails.any? && x.assigned_user_id == system_pipeline_user_id }
    logger.info "Found #{leads.length.to_s} dead leads that are 7 days old and did not got a dead client email"

    leads.each do |lead|
      email = lead.email
      logger.info "#{lead.name} will get an email to #{email}"

      begin
        StatusEmails.dead(email).deliver
        lead.custom_data.dead_client_email_sent_c = Time.now
        lead.save

        Note.add lead.id, "Dead email was sent 7 days after dead status was assigned"
      rescue => ex
        logger.info "Email sending returned error response: " + ex.meesage
      end

      sleep 5
    end

    logger.info "#{leads.length.to_s} cancelled leads got an email"
  end
end

job = DeadEmailJob.new
job.execute
