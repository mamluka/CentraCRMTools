require_relative "lib/jobs-base"
require_relative "../emails/mailer_base"

class JobAssignLeadsToSystemPipelineJob < JobsBase

  def execute
    leads = CustomData.where('prev_url_c != ?', 'http://').select { |x| !x.do_not_email && x.system_pipeline_email_1_c.nil? }.map { |x| x.lead }.select { |x| x.emails.any? }.select { |x| x.status =="FU" && x.date_entered < 7.days.ago }

    logger.info "Found #{leads.length.to_s} that are 7 days old and still in follow up status"

    leads.each do |lead|
      lead.status = 'SP'
      lead.assigned_user_id = system_pipeline_user_id

      begin
        email = lead.email
        logger.info "#{lead.name} will get an email to #{email}"

        SystemPipelineEmails.first_system_pipeline(email, lead.custom_data.prev_url_c).deliver

        lead.custom_data.system_pipeline_email_1_c = Time.now
        lead.save

        Note.add lead.id, "System pipeline email #1 was sent a week after a lead moved to System pipeline user"
      rescue => ex
        logger.info "Email response was: " + ex.message
      end

      sleep wait_between_emails_interval
    end

    logger.info "#{leads.length.to_s} send system pipeline email #1"
  end
end

job = JobAssignLeadsToSystemPipelineJob.new
job.execute

