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

    start_api
  end

  def teardown
    @email_client.clear_inbox

    stop_api
  end

  def capture_failed_snapshot(driver)
    if !@passed
      driver.screenshot.save @__name__ + '.png'
    end

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

    assert Mail.all.map { |x| x.multipart? ? x.parts.first.body : x.body }.any? { |x| x.include?(text) }
  end

  def assert_email_not_sent
    email_count = @email_client.wait_for_emails

    if email_count > 0
      flunk "Email was found"
    end

  end

  def assert_note_added(id, message)
    assert Note.where("parent_id =? and name like '%#{message}%'", id).any?
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

  def start_api
    `screen -L -dmS echosign thin -d -a soa.centracorporation.com -p 9050 -V -R #{File.dirname(__FILE__)}/../../api/config.ru start`
  end

  def stop_api
    `screen -L -dmS echosign thin -p 9050 stop`
  end

end