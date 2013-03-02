require 'minitest/autorun'
require 'watir-webdriver'
require 'securerandom'

require_relative '/base/crm-test-base.rb'

class TestMini < CrmTestBase

  def test_when_verify_is_checked_sendout_the_google_info_head_up_email
    enable_email_sending

    lead = CrmLead.new @driver, {
        :status => 'select Client',
        :googlelocal_check_c => 'check',
        :googlelocal_verified_c => 'check',
        :email => "email crmtesting@centracorporation.com",
    }

    assert_email_contains 'Thank you for taking advantage in the Google Local Listing Management program from Centra'
    assert_email_contains 'http://centracorporation.com/google-local-listing-code#!' + lead.id
  end
end