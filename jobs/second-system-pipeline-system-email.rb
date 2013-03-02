require_relative "lib/jobs-base"

class SecondSystemPipelineEmailJob < JobsBase

  def execute
    leads = CustomData.where('system_pipeline_email_1_c < ? and system_pipeline_email_2_c is null', 7.days.ago).select { |x| !x.do_not_email }.map { |x| x.lead }.select { |x| x.status =="SP" && x.emails.any? && x.assigned_user_id == system_pipeline_user_id }
    logger.info "Found #{leads.length.to_s} system pipeline leads that got email #1 a week ago"

    leads.each do |lead|
      email = lead.email
      logger.info "#{lead.name} will get an cancellation email to #{email}"

      res = mailer.second_system_pipeline email, lead.custom_data.prev_url_c

      if res=="OK"
        lead.custom_data.system_pipeline_email_2_c = Time.now
        lead.save
      else
        logger.info "Api returned an error " + res
      end

      sleep 5

    end

    logger.info "#{leads.length.to_s} leads got system pipeline email #2"
  end
end

job = SecondSystemPipelineEmailJob.new
job.execute