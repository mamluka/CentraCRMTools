require 'rubygems'
require 'active_record'
require 'active_support/all'
require 'logging'
require 'rest_client'

load 'lib/emailer.rb'

ActiveRecord::Base.establish_connection(
    :adapter => 'mysql2',
    :database => 'jdeering_centracrm',
    :username => 'jdeering_david',
    :password => '0953acb',
    :host => 'centracorporation.com')

class StandardLogger
  def self.get
    logger = Logging.logger['logger']
    logger.add_appenders(
        Logging.appenders.stdout,
        Logging.appenders.file(
            'centra.log',
            :layout => Logging.layouts.pattern(:pattern => '[%d]: %m\n')
        )
    )

    logger.level = :info
    logger
  end
end

$system_pipeline_user_id = '92b0bdb7-bb6c-449f-fa73-510054673707'
$centra_small_business_user_id = 'b2f5c6ac-4dcf-8c27-e381-51083846f181'