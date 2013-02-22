require 'json'
require 'time'

require File.dirname(__FILE__) + "/../../core/tests-base.rb"

class CrmTestBase < TestsBase

  @@crm_php_script = "/home/davidmz/sugarcrm/custom/modules/Leads/CentraLeads.php"

  def setup
    super
    @driver = Watir::Browser.new :phantomjs
    @auth = Auth.new @driver
    @auth.login

    load_database
    clean_databases

    `screen -L -dmS api ruby #{File.dirname(__FILE__)}/api-interceptor.rb`

  end

  def teardown
    super
    @auth.logout
    disable_email_sending

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

  def enable_email_sending
    `sed -i 's/http:\\/\\/localhost:4567\\/api/http:\\/\\/apps.centracorporation.com\\/api/g' #{@@crm_php_script}`
  end

  def disable_email_sending
    `sed -i 's/http:\\/\\/apps.centracorporation.com\\/api/http:\\/\\/localhost:4567\\/api/g' #{@@crm_php_script}`
  end
end