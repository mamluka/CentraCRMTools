require File.dirname(__FILE__) + "/email-assertions.rb"
require 'active_record'
require 'mail'

class TestsBase < MiniTest::Unit::TestCase

  def setup
    @email_assertions = EmailAssertions.new
    @email_assertions.clear_inbox
  end

  def teardown
    @email_assertions.clear_inbox
  end

  def today_crm_time
    Time.now.strftime('%Y-%m-%d %H:%M')
  end

  def today_crm_date
    Date.today.strftime('%m/%d/%Y')
  end

  def assert_email_contains(text)
    time_elapsed = 0
    while Mail.all.length == 0 && time_elapsed < 30
      sleep 5
      time_elapsed +=5
    end

    if Mail.all.length == 0
      flunk "No email found"
    end

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