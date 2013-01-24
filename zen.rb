require 'rubygems'
require 'active_record'
require 'active_support/all'
require 'logging'

ActiveRecord::Base.establish_connection(
    :adapter => 'mysql2',
    :database => 'jdeering_centracrm',
    :username => 'jdeering_david',
    :password => '0953acb',
    :host => 'centracorporation.com')

class Lead < ActiveRecord::Base
end

class LeadsCustomData < ActiveRecord::Base
  set_table_name 'leads_cstm'
  set_primary_key  'id_c'
end

logger = Logging.logger['logger']
logger.add_appenders(
    Logging.appenders.stdout,
    Logging.appenders.file('centra.log')
)

logger.level = :info

week_old_leads = Lead.where(:status => 'SP')

logger.info "We have found #{week_old_leads.to_s} leads"

week_old_leads.each do |lead|

  LeadsCustomData.

end

logger.info "we have modified:  #{week_old_leads.length.to_s} leads"