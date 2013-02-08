load File.dirname(__FILE__) + '/lib/init.rb'
load File.dirname(__FILE__) + '/lib/active_records_models.rb'

logger = StandardLogger.get

leads = Lead.all

pit_shop_leads = leads.select do |lead|
  lead.emails.empty? || (!lead.custom_data.nil? && lead.custom_data.not_billable_c = 1 && (lead.custom_data.non_billable_reason_c == "invalid_email" || lead.custom_data.non_billable_reason_c == "invalid_url"))
end

logger.info "Found #{pit_shop_leads.length.to_s} pit stop leads"

pit_shop_leads.each do |lead|
  lead.status = 'pitstop'
  lead.assigned_user_id = $system_pipeline_user_id
  logger.info "Moved #{lead.name} to system pipline user"

  lead.save
end

logger.info "Moved #{pit_shop_leads.length.to_s} pit stop leads to system pipeline user"

