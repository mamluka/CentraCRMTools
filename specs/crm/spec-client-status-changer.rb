require 'minitest/autorun'
require 'watir-webdriver'

require_relative 'base/crm-test-base.rb'

class TestMini < CrmTestBase
  def test_when_change_status_to_client_should_update_assigner_user
    lead = CrmLead.new @driver, {
        :status => 'select Client',
        :mobileweb_check_c => 'check',
        :mobileweb_contract_type_c => 'select Centra 24',
        :email => "email crmtesting@centracorporation.com"
    }

    assert_equal lead.get('rep_client_status_changed_c'), "David MZ"
    assert_includes lead.get('client_status_change_date_c'), today_crm_date
  end
end