load 'init.rb'
load 'active_records_models.rb'

logger = StandardLogger.get

dead_leads = Lead.where('status = ?', 'client')

logger.info "Found #{dead_leads.length.to_s} clients"

dead_leads.each do |lead|
  lead.assigned_user_id = $centra_small_business_user_id
  logger.info "Moved #{lead.first_name} #{lead.last_name} to centra small business user"

  lead.save
end

logger.info "#{dead_leads.length.to_s} clients were moved to centra small business"