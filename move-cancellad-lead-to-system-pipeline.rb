load 'init.rb'
load 'active_records_models.rb'

logger = StandardLogger.get

cancelled_leads = Lead.where('status = ?','cancelled')

logger.info "Found #{cancelled_leads.length.to_s} cancelled leads to move"

cancelled_leads.each do |lead|
  lead.assigned_user_id = $system_pipeline_user_id
  lead.custom_date.cancellation_change_date_c = Time.now
  lead.save
end

logger.info "Moved #{cancelled_leads.length.to_s} leads to system pipeline"