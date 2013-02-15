require 'minitest/autorun'
require 'watir-webdriver'
require 'securerandom'

require File.dirname(__FILE__) + '/base/auth.rb'
require File.dirname(__FILE__) + '/base/lead.rb'
require File.dirname(__FILE__) + '/base/crm_test_base.rb'

class TestMini < CrmTestBase

  def setup
    @driver = Watir::Browser.new :phantomjs
    `screen -L -dmS api ruby base/api-interceptor.rb`
  end

  def teardown
    `pkill -f api-interceptor.rb`
  end

  def test_this_test
    auth = Auth.new @driver
    auth.login

    email = "#{SecureRandom.uuid}@david.com"

    lead = Lead.new @driver,
                    {:prev_url_c => 'http://preview.flowmobileapps.com/compare/testing',
                     :email => "email #{email}"
                    }

    assert_api_called({:email => email, :previewUrl => 'http://preview.flowmobileapps.com/compare/testing'})
    assert lead.get('mobile_preview_email_sent_c') == Date.today.strftime('%d/%m/%Y')
    assert lead.status == "Assigned"
  end
end
	




