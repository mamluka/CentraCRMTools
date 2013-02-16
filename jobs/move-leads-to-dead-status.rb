require File.dirname(__FILE__) + '/lib/init.rb'
require File.dirname(__FILE__) + '/lib/active_records_models.rb'

logger = StandardLogger.get

leads = Lead.where('assigned_user_id != ?', $system_pipeline_user_id)

dead_leads = leads.select do |lead|
  !lead.custom_data.nil? && lead.custom_data.not_billable_c = 1 && lead.custom_data.non_billable_reason_c == "not_interested"
end

logger.info "Found #{dead_leads.length.to_s} leads that are not billable and not interested"

dead_leads.each do |lead|
  lead.status = 'Dead'
  lead.assigned_user_id = $system_pipeline_user_id
  logger.info "Moved #{lead.name} to system pipline user"

  lead.save
end

logger.info "Moved #{dead_leads.length.to_s} leads that are not billable and not interested"

