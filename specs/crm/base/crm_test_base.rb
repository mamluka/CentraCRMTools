require 'json'
require 'time'

class CrmTestBase < MiniTest::Unit::TestCase

  def setup
    @driver = Watir::Browser.new :phantomjs
    @auth = Auth.new @driver
    @auth.login

    `screen -L -dmS api ruby #{File.dirname(__FILE__)}/api-interceptor.rb`
  end

  def teardown
    @auth.logout

    `pkill -f api-interceptor.rb`
    `rm -rf /tmp/api-call.json`
  end

  def assert_api_called(params)
    actual_api_call = JSON.parse(File.read('/tmp/api-call.json'))

    params.each do |k, v|
      assert actual_api_call.has_key?(k.to_s) && actual_api_call[k.to_s] == v
    end
  end

  def assert_api_not_called
    assert !File.exists?('api-call.json'), "Api call file exists"
  end

  def today_crm_time
    Time.now.strftime('%Y-%m-%d %H:%M')
  end

  def today_crm_date
    Date.today.strftime('%m/%d/%Y')
  end
end