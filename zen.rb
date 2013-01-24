require 'rubygems'
require 'active_record'
require 'active_support/all'
require 'logging'
require 'rest_client'

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


class EmailAddress < ActiveRecord::Base
  set_table_name 'email_addresses'
end

class EmailAddressRelation < ActiveRecord::Base
  set_table_name 'email_addr_bean_rel'
end

logger = Logging.logger['logger']
logger.add_appenders(
    Logging.appenders.stdout,
    Logging.appenders.file('centra.log')
)

logger.level = :info

leads = Lead.where(:status => 'SP')

logger.info "We have found #{leads.length.to_s} leads"

leads.each do |lead|

  custom_data = LeadsCustomData.find(lead.id)

  if custom_data.prev_url_c != "http://" && EmailAddressRelation.exists?(:bean_id => lead.id)
    logger.info "loaded custom data for #{lead.first_name} the data has in it #{custom_data.prev_url_c}"

    rel = EmailAddressRelation.where(:bean_id => lead.id).first
    email = EmailAddress.find(rel.email_address_id)

    logger.info "it has the email: #{email.email_address}"

    res = RestClient.get 'http://apps.centracorporation.com/api/email/first-system-pipeline', {:params=> { :email => email.email_address,:previewUrl =>  custom_data.prev_url_c}}

    logger.info "The api call response: #{res}"

    if res == "OK"
      custom_data.system_pipeline_email_1_c = Time.now
      custom_data.save

      logger.info "Saved the new status"
    end

    sleep 3

    logger.info "--Done--"
  end



end