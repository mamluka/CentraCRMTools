require File.dirname(__FILE__) + '/lib/init.rb'
require File.dirname(__FILE__) + '/lib/active_records_models.rb'

logger = StandardLogger.get

cancelled_leads = Lead.where('status = ?','cancelled').select do  |x|
  !x.custom_data.nil?
end


logger.info "Found #{cancelled_leads.length.to_s} cancelled leads to move"

cancelled_leads.each do |lead|
  lead.assigned_user_id = $system_pipeline_user_id
  lead.custom_data.cancellation_change_date_c = Time.now
  lead.save
end

logger.info "Moved #{cancelled_leads.length.to_s} leads to system pipeline"