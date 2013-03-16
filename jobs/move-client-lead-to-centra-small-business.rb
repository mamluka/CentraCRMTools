require_relative "lib/jobs-base"

class MoveCancelledLeadsToSystemPipelineJob < JobsBase

  def execute
    leads = Lead.where('status = ? and assigned_user_id != ?', 'client', centra_small_business_user_id).select { |x| !x.custom_data.nil? }
    logger.info "Found #{leads.length.to_s} clients to move to centra small business"

    leads.each do |lead|
      lead.assigned_user_id = centra_small_business_user_id
      logger.info "Moved #{lead.name } to centra small business user"

      lead.save

      Note.add lead.id, "Moved to system pipeline because lead became a client"
    end

    logger.info "#{leads.length.to_s} clients moved to centra small business"
  end
end

job = MoveCancelledLeadsToSystemPipelineJob.new
job.execute
