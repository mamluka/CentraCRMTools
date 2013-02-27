require 'minitest/autorun'
require 'watir-webdriver'

require_relative '/base/crm-test-base.rb'

class TestMini < CrmTestBase
  def test_when_change_status_to_cancelled_should_update_assigner_user

    lead = Lead.new @driver, {
        :status => 'select Cancelled',
        :assigned_user_id => 'hidden 54c61b2e-43ab-6c5e-8e5b-50c60d1a5960'
    }

    assert_equal lead.get('cancelling_rep_c'), "David MZ"
    assert_includes lead.get('original_rep_c'), 'Paul J. Antonitis'
  end
end