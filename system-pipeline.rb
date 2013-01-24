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

logger = Logging.logger['logger']
logger.add_appenders(
    Logging.appenders.stdout,
    Logging.appenders.file('centra.log')
)

logger.level = :info

week_old_leads = Lead.where('date_entered < ? and status= ?', 7.day.ago, 'FU')

logger.info "We have found #{week_old_leads.to_s} leads"

week_old_leads.each do |lead|
  lead.status = 'SP'
  lead.assigned_user_id = '92b0bdb7-bb6c-449f-fa73-510054673707'
  lead.save
end

logger.info "we have modified:  #{week_old_leads.length.to_s} leads"

