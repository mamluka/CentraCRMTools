require "logger"

require_relative "../../core/emailer"
require_relative "../../core/crm-database"


class JobsBase
  def connect_to_db
    crm_database = CrmDatabase.new
    crm_database.connect
  end

  def get_logger
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