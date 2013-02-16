require 'active_record'
require 'active_support/all'

class JobsTestBase < MiniTest::Unit::TestCase

  def reload_database
    current_dir = File.dirname(__FILE__)
    config = JSON.parse(File.read("#{current_dir}/database.json"))

    ActiveRecord::Base.establish_connection(
        :adapter => 'mysql2',
        :database => config['database'],
        :username => config['username'],
        :password => config['password'],
        :host => config['host'])
  end
end