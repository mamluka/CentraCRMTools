require_relative "lib/jobs-base"

class MoveCancelledLeadsToSystemPipelineJob < JobsBase

  def execute
    leads = Lead.where('status = ? and assigned_user_id != ?', 'cancelled', system_pipeline_user_id).select { |x| !x.custom_data.nil? }
    logger.info "Found #{leads.length.to_s} cancelled leads to move to system pipeline"

    leads.each do |lead|
      lead.assigned_user_id = system_pipeline_user_id

      lead.save
    end

    logger.info "#{leads.length.to_s} cancelled leads moved to system  pipeline"
  end
end

job = MoveCancelledLeadsToSystemPipelineJob.new
job.execute
