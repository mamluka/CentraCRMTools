require 'minitest/autorun'
require 'active_record'
require 'active_support/all'
require 'securerandom'

current_dir = File.dirname(__FILE__)

require current_dir + "/../../../jobs/lib/init.rb"
require current_dir + "/../../../jobs/lib/active_records_models.rb"
require current_dir + "/email-assertions.rb"

$test_user_id = '8d71be80-cc24-cda3-e4d6-50d8a70d9d20'

class JobsTestBase < MiniTest::Unit::TestCase

  @@current_dir = File.dirname(__FILE__)

  def setup
    reload_database
    clean_databases

    @emails.clear_inbox
  end

  def clean_databases
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

  def lead_with
    lead = Lead.new
    lead.assigned_user_id =$test_user_id
    lead.first_name = SecureRandom.uuid
    lead.last_name = SecureRandom.uuid

    yield lead

    lead.save
    lead.add_email "crmtesting@centracorporation.com"

    lead.add_custom_data

    lead.save
    lead
  end

  def email
    @emails ||= EmailAssertions.new
  end

end