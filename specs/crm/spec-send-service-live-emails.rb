require 'minitest/autorun'
require 'watir-webdriver'
require 'securerandom'

require_relative 'base/crm-test-base.rb'

class TestMini < CrmTestBase

  def test_when_mobile_web_is_live_should_email_the_client_that_its_live

    CrmLead.new @driver, {
        :status => 'select Client',
        :mobileweb_check_c => 'check',
        :mobileweb_live_c => 'check',
        :email => "email crmtesting@centracorporation.com",
        :mobileweb_contract_type_c => 'select Centra 24'
    }

    assert_email_contains 'Your mobile website is now live and available for you to check out'
  end

  def test_when_mobile_web_is_live_should_update_assigner_and_assogn_date

    lead = CrmLead.new @driver, {
        :status => 'select Client',
        :mobileweb_check_c => 'check',
        :mobileweb_live_c => 'check',
        :email => "email crmtesting@centracorporation.com",
        :mobileweb_contract_type_c => 'select Centra 24'
    }

    assert_equal lead.get('mobileweb_live_date_c'), today_crm_date
    assert_equal lead.get('mobileweb_live_assigner_c'), 'David MZ'

  end

  def test_when_mobile_web_is_live_should_add_note

    lead = CrmLead.new @driver, {
        :status => 'select Client',
        :mobileweb_check_c => 'check',
        :mobileweb_live_c => 'check',
        :email => "email crmtesting@centracorporation.com",
        :mobileweb_contract_type_c => 'select Centra 24'
    }

    assert_note_added lead.id, "Mobile web was set to live by David MZ"
  end


  def test_when_local_listing_is_live_should_email_the_client

    CrmLead.new @driver, {
        :status => 'select Client',
        :googlelocal_check_c => 'check',
        :googlelocal_live_c => 'check',
        :email => "email crmtesting@centracorporation.com",
        :googlelocal_contract_type_c => 'select Centra 99'
    }

    assert_email_contains 'Google has indexed your listing and is now live at its most basic level'
  end

  def test_when_local_listing_is_live_should_add_note

    lead = CrmLead.new @driver, {
        :status => 'select Client',
        :googlelocal_check_c => 'check',
        :googlelocal_live_c => 'check',
        :email => "email crmtesting@centracorporation.com",
        :googlelocal_contract_type_c => 'select Centra 99'
    }

    assert_note_added lead.id, "Google local listing is set live by David MZ"
  end

  def test_when_local_listing_is_live_save_who_did_it_and_when

    lead = CrmLead.new @driver, {
        :status => 'select Client',
        :googlelocal_check_c => 'check',
        :googlelocal_live_c => 'check',
        :email => "email crmtesting@centracorporation.com",
        :googlelocal_contract_type_c => 'select Centra 99'
    }

    assert_equal lead.get('googlelocal_live_assign_name_c'), 'David MZ'
    assert_equal lead.get('googlelocal_live_assign_date_c'), today_crm_date

  end
end