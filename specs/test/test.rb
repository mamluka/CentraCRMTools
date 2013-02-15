require 'minitest/autorun'
require 'watir-webdriver'

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

    lead = Lead.new @driver,
                    {:prev_url_c => 'http://preview.flowmobileapps.com/compare/lqtravel',
                     :company_name_c => 'testing',
                     :status => 'select Dead',
                     :email => 'email david@david.com'
                    }

    puts lead.id
  end
end
	




