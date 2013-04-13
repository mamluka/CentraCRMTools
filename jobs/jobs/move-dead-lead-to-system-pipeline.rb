require_relative '../lib/jobs-base'
require_relative '../../emails/mailer_base'

class MoveDeadLeadsToSystemPipelineJob < JobsBase

  def execute
    leads = Lead.where('status = ? and assigned_user_id != ?', 'Dead', system_pipeline_user_id).select { |x| !x.custom_data.nil? }
    logger.info "Found #{leads.length.to_s} dead leads to move to system pipeline"

    leads.each do |lead|
      lead.assigned_user_id = system_pipeline_user_id

      logger.info "Moved #{lead.name} to system pipeline"
      lead.save

      Note.add lead.id, "Moved to system pipeline because the lead is dead"
    end

    logger.info "#{leads.length.to_s} dead leads moved to system  pipeline"
  end
end

job = MoveDeadLeadsToSystemPipelineJob.new
job.execute