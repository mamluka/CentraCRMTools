require 'active_record'
require_relative 'models'

class CrmDatabase

  def connect
    unless ActiveRecord::Base.connected?

      config = JSON.parse(File.read(File.dirname(__FILE__) + "/database.json"))

      ActiveRecord::Base.configurations["crm"] = {
          :adapter => 'mysql2',
          :database => config['database'],
          :username => config['username'],
          :password => config['password'],
          :host => config['host']
      }
    end
  end
end