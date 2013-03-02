require 'minitest/autorun'
require 'watir-webdriver'

require_relative '/base/crm-test-base.rb'

class TestMini < CrmTestBase
  def test_when_change_status_to_dead_should_update_assigner_user
    lead = CrmLead.new @driver, {:status => 'select Dead'}

    assert_equal lead.get('dead_status_assigner_c'), "David MZ"
    assert_includes lead.get('dead_status_assigned_date_c'), today_mysql_time
  end
end