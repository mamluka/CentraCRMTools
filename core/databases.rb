require 'active_record'

class Databases

  def connect
    unless ActiveRecord::Base.connected?

      config = JSON.parse(File.read(File.dirname(__FILE__) + "/database.json"))

      ActiveRecord::Base.configurations['crm'] = {
          :adapter => 'mysql2',
          :database => config['crn_database'],
          :username => config['crm_username'],
          :password => config['crm_password'],
          :host => config['crm_host']
      }

      ActiveRecord::Base.configurations['otrs'] = {
          :adapter => 'mysql2',
          :database => config['otrs_database'],
          :username => config['otrs_username'],
          :password => config['otrs_password'],
          :host => config['otrs_host']
      }

      require_relative 'crm-models'
    end
  end
end