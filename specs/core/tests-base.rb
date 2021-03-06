require_relative "email-client"
require_relative "crm-lead"
require_relative "auth"
require_relative "../../core/databases"
require 'rest-client'

require 'active_record'
require 'mail'
require 'time'

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
    ActiveRecord::Base.establish_connection 'crm'

    ActiveRecord::Base.connection.execute("DELETE FROM leads;")
    ActiveRecord::Base.connection.execute("DELETE FROM leads_cstm;")
    ActiveRecord::Base.connection.execute("DELETE FROM email_addresses;")
    ActiveRecord::Base.connection.execute("DELETE FROM email_addr_bean_rel;")

    ActiveRecord::Base.establish_connection 'otrs'

    ActiveRecord::Base.connection.execute("DELETE FROM customer_user;")

  end

  def load_database

  end

  def start_api
    `screen -L -dmS echosign rackup -p 9050 -d #{File.dirname(__FILE__)}/../../soa/config.ru`
  end

  def stop_api

    `pkill -9 -f 9050`

    counter = 0
    until `ps aux | grep 9050 | grep -v grep`.empty? || counter < 100
      sleep 0.1
      counter=counter+1
    end
  end

  def wait_for_api

    @base_url = JSON.parse(File.read(File.dirname(__FILE__) + '/crm-config.json'))['soa_base_url']

    while begin
      RestClient.get @base_url + '/forms/invalid-url'
      break
    rescue Errno::ECONNREFUSED
      sleep 1
    end
    end
  end

end