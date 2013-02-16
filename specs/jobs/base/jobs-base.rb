require 'minitest/autorun'
require 'active_record'
require 'active_support/all'

current_dir = File.dirname(__FILE__)

require current_dir + "/../../../jobs/lib/init.rb"
require current_dir + "/../../../jobs/lib/active_records_models.rb"

class JobsTestBase < MiniTest::Unit::TestCase

  @@current_dir = File.dirname(__FILE__)

  def setup
    reload_database
    ActiveRecord::Base.connection.execute("DELETE FROM leads;")
    ActiveRecord::Base.connection.execute("DELETE FROM leads_cstm;")
    ActiveRecord::Base.connection.execute("DELETE FROM email_addresses;")
    ActiveRecord::Base.connection.execute("DELETE FROM email_addr_bean_rel;")
  end

  def reload_database

    config = JSON.parse(File.read("#{@@current_dir}/database.json"))

    ActiveRecord::Base.establish_connection(
        :adapter => 'mysql2',
        :database => config['database'],
        :username => config['username'],
        :password => config['password'],
        :host => config['host'])
  end

  def load_job(job_file)
    load @@current_dir + '/../../../jobs/' + job_file +'.rb'
  end

  def today_crm_time
    Time.now.strftime('%Y-%m-%d %H:%M')
  end

  def today_crm_date
    Date.today.strftime('%m/%d/%Y')
  end

end