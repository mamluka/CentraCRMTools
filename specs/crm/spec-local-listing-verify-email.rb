require 'minitest/autorun'
require 'watir-webdriver'
require 'securerandom'

require_relative 'base/crm-test-base.rb'

class TestMini < CrmTestBase

  def test_when_verify_is_checked_shoould_sendout_the_google_info_head_up_email

    lead = CrmLead.new @driver, {
        :status => 'select Client',
        :googlelocal_check_c => 'check',
        :googlelocal_verified_c => 'check',
        :googlelocal_contract_type_c => 'select Centra 99',
        :email => "email crmtesting@centracorporation.com",
    }

    assert_email_contains 'Thank you for taking advantage in the Google Local Listing Management program from Centra'
    assert_email_contains 'http://centracorporation.com/google-local-listing-code#!' + lead.id
  end

  def test_when_verify_is_checked_shoould_add_note

    lead = CrmLead.new @driver, {
        :status => 'select Client',
        :googlelocal_check_c => 'check',
        :googlelocal_verified_c => 'check',
        :googlelocal_contract_type_c => 'select Centra 99',
        :email => "email crmtesting@centracorporation.com",
    }

    assert_note_added lead.id, "Google local listing pin was entered"
  end

  def test_when_verify_is_checked_shoould_update_verified_date

    lead = CrmLead.new @driver, {
        :status => 'select Client',
        :googlelocal_check_c => 'check',
        :googlelocal_verified_c => 'check',
        :googlelocal_contract_type_c => 'select Centra 99',
        :email => " email crmtesting @centracorporation.com "
    }

    assert_equal lead.get('googlelocal_verified_date_c'), today_crm_date

  end
end