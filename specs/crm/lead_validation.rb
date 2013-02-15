require 'minitest/autorun'
require 'watir-webdriver'

require File.dirname(__FILE__) + '/base/auth.rb'
require File.dirname(__FILE__) + '/base/lead.rb'
require File.dirname(__FILE__) + '/base/crm_test_base.rb'

class TestMini < CrmTestBase

  def test_when_changed_to_client_status_should_validate_sold_services
    lead = Lead.new @driver, {:status => 'client'}

    puts @driver.text
  end

end