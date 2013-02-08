load File.dirname(__FILE__) + '/lib/init.rb'
load File.dirname(__FILE__) + '/lib/active_records_models.rb'

logger = StandardLogger.get

leads = Lead.where('status = ?', 'SP').select { |lead| lead.assigned_user_id != $system_pipeline_user_id }
non_mailable_leads = leads.select { |lead| lead.custom_data.do_not_email_c = 1 }

logger.info "Found #{non_mailable_leads.length.to_s} leads that are system pipeline and have do not email checked"

non_mailable_leads.each do |lead|
  lead.assigned_user_id = $system_pipeline_user_id

  if not lead.custom_data.nil?
    lead.custom_data.dead_status_assigner_c = 'System Pipeline'
  else
    logger.info "This user has no extra data strange?"
  end

  logger.info "Moved #{lead.first_name} #{lead.last_name} to dead status"
  lead.save
end

logger.info "#{non_mailable_leads.length.to_s} dead leads moved to system pipeline user"

