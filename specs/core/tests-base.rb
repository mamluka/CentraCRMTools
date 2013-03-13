require_relative "email-client"
require_relative "crm-lead"
require_relative "auth"
require_relative "../../core/crm-database"

require 'active_record'
require 'mail'

class TestsBase < MiniTest::Unit::TestCase

  def setup
    @email_client = EmailClient.new
    @email_client.clear_inbox

    start_echosign
  end

  def teardown
    @email_client.clear_inbox

    stop_echosign


  end

  def today_mysql_time
    Time.now.strftime('%Y-%m-%d %H:%M')
  end

  def today_crm_date
    Date.today.strftime('%m/%d/%Y')
  end

  def today_crm_time
    Time.now.strftime('%m/%d/%Y %H:%M')
  end

  def assert_email_contains(text)

    email_count = @email_client.wait_for_emails

    if email_count == 0
      flunk "No emails found"
    end

    assert Mail.all.each { |x| x.multipart? ? x.parts.first.body : x.body }.any? { |x| x.include?(text) }
  end

  def assert_email_not_sent
    email_count = @email_client.wait_for_emails

    if email_count > 0
      flunk "Email was found"
    end

  end

  def clean_databases
    ActiveRecord::Base.connection.execute("DELETE FROM leads;")
    ActiveRecord::Base.connection.execute("DELETE FROM leads_cstm;")
    ActiveRecord::Base.connection.execute("DELETE FROM email_addresses;")
    ActiveRecord::Base.connection.execute("DELETE FROM email_addr_bean_rel;")
  end

  def load_database
    crm_database = CrmDatabase.new
    crm_database.connect
  end

  def start_echosign
    `screen -L -dmS echosign  rackup -p 9050 #{File.dirname(__FILE__)}/../../echosign/config.ru`
  end

  def stop_echosign
    `pkill -f 9050`
  end

end