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

logger = Logging.logger['logger']
logger.add_appenders(
    Logging.appenders.stdout,
    Logging.appenders.file(
        'centra.log',
        :layout => Logging.layouts.pattern(:pattern => '[%d]: %m\n')
    )
)

logger.level = :info