require_relative "email-client"
require_relative "lead"
require_relative "auth"
require_relative "email-client"

require 'active_record'
require 'mail'

class TestsBase < MiniTest::Unit::TestCase

  def setup
    @email_client = EmailClient.new
    @email_client.clear_inbox
  end

  def teardown
    @email_client.clear_inbox
  end

  def today_mysql_time
    Time.now.strftime('%Y-%m-%d %H:%M')
  end

  def today_crm_date
    Date.today.strftime('%m/%d/%Y')
  end

  def today_crm_time
    Date.today.strftime('%m/%d/%Y %H:%M')
  end

  def assert_email_contains(text)

    @email_client.wait_for_emails

    if Mail.first.multipart?
      assert_includes Mail.first.parts.first.body, text
    else
      assert_includes Mail.first.body, text
    end

  end

  def clean_databases
    ActiveRecord::Base.connection.execute("DELETE FROM leads;")
    ActiveRecord::Base.connection.execute("DELETE FROM leads_cstm;")
    ActiveRecord::Base.connection.execute("DELETE FROM email_addresses;")
    ActiveRecord::Base.connection.execute("DELETE FROM email_addr_bean_rel;")
  end

  def load_database

    config = JSON.parse(File.read("#{File.dirname(__FILE__)}/database.json"))

    ActiveRecord::Base.establish_connection(
        :adapter => 'mysql2',
        :database => config['database'],
        :username => config['username'],
        :password => config['password'],
        :host => config['host'])
  end
end