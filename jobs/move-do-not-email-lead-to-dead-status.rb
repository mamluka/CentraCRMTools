require_relative "lib/jobs-base"

class MoveDoNotEmailToDeadStatusJob < JobsBase

  def execute
    leads = CustomData.where(:do_not_email_c => 1).map { |x| x.lead }.select { |x| x.status != "SP" }
    logger.info "Found #{leads.length.to_s} leads that are have do not email checked and belong to system pipeline"

    leads.each do |lead|
      lead.assigned_user_id = system_pipeline_user_id
      lead.status = "Dead"
      lead.custom_data.dead_status_assigner_c = 'System Pipeline'

      logger.info "Moved #{lead.name} to dead status"

      lead.save
    end

    logger.info "#{leads.length.to_s} moved to dead status"
  end
end

job = MoveDoNotEmailToDeadStatusJob.new
job.execute