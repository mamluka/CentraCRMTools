require 'minitest/autorun'
require 'watir-webdriver'
require 'securerandom'

require File.dirname(__FILE__) + '/base/auth.rb'
require File.dirname(__FILE__) + '/base/lead.rb'

class TestMini < MiniTest::Unit::TestCase

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
  end
end
	




