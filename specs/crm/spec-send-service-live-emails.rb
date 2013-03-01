require 'minitest/autorun'
require 'watir-webdriver'
require 'securerandom'

require_relative '/base/crm-test-base.rb'

class TestMini < CrmTestBase

  def test_when_mobile_web_is_live_should_email_the_client_that_its_live

    enable_email_sending

    Lead.new @driver, {
        :status => 'select Client',
        :mobileweb_check_c => 'check',
        :mobileweb_live_c => 'check',
        :email => "email crmtesting@centracorporation.com",
    }

    assert_email_contains 'Your mobile website is now live and available for you to check out'
  end

  def test_when_local_listing_is_live_should_email_the_client

    enable_email_sending

    Lead.new @driver, {
        :status => 'select Client',
        :googlelocal_check_c => 'check',
        :googlelocal_live_c => 'check',
        :email => "email crmtesting@centracorporation.com",
    }

    assert_email_contains 'Google has indexed your listing and is now live at its most basic level'
  end
end