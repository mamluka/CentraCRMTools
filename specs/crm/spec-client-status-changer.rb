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

  def test_when_change_status_to_client_should_add_note
    lead = CrmLead.new @driver, {
        :status => 'select Client',
        :mobileweb_check_c => 'check',
        :mobileweb_contract_type_c => 'select Centra 24',
        :email => "email crmtesting@centracorporation.com"
    }

    assert_note_added lead.id, "Client status was assigned by David MZ"
  end

  def test_when_lead_is_assgined_and_a_save_is_made_should_move_to_follow_ip
    lead = CrmLead.new @driver, {
        :email => "email crmtesting@centracorporation.com"
    }

    lead.edit :status => 'select Assigned'
    lead.edit :description => 'new note'

    assert_equal lead.get_list('status'), 'FU'

  end
end