require "logging"
require "securerandom"
require 'time'
require 'json'

require_relative "../../core/databases"

class JobsBase

  def initialize
    @logger = get_logger
    @config = JSON.parse(File.read(File.dirname(__FILE__) +'/config.json'))
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

  def wait_between_emails_interval
    @config['wait_between_emails'].to_i
  end

  def system_pipeline_user_id
    '92b0bdb7-bb6c-449f-fa73-510054673707'
  end

  def centra_small_business_user_id
    'b2f5c6ac-4dcf-8c27-e381-51083846f181'
  end
end