require "logging"
require "securerandom"
require 'time'

require_relative "../../core/emailer"
require_relative "../../core/crm-database"

class JobsBase

  def initialize
    connect_to_db
    @logger = get_logger
    @mailer = ApiEmailer.new
  end

  def connect_to_db
    crm_database = CrmDatabase.new
    crm_database.connect
  end

  def get_logger
    logger = Logging.logger[SecureRandom.uuid]
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

  def logger
    @logger
  end

  def mailer
    @mailer
  end

  def system_pipeline_user_id
    '92b0bdb7-bb6c-449f-fa73-510054673707'
  end

  def centra_small_business_user_id
    'b2f5c6ac-4dcf-8c27-e381-51083846f181'
  end
end