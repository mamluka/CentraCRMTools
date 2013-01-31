load 'init.rb'
load 'active_records_models.rb'

logger = StandardLogger.get

dead_leads = Lead.where('status = ? and assigned_user_id != ?','Dead',$system_pipeline_user_id)

logger.info "Found #{dead_leads.length.to_s} dead leads"

dead_leads.each do |lead|
  lead.assigned_user_id = $system_pipeline_user_id
  if not lead.custom_data.nil?
    lead.custom_data.dead_status_assigned_date_c = Time.now
  else
    logger.info "This user has no extra data strange?"
  end

  logger.info "Moved #{lead.first_name} #{lead.last_name} to system pipline user"
  lead.save
end

logger.info "#{dead_leads.length.to_s} dead leads moved to system pipeline user"

