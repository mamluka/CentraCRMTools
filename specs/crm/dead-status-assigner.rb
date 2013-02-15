require 'minitest/autorun'
require 'watir-webdriver'

require File.dirname(__FILE__) + '/base/auth.rb'
require File.dirname(__FILE__) + '/base/lead.rb'
require File.dirname(__FILE__) + '/base/crm_test_base.rb'

class TestMini < CrmTestBase
  def test_when_change_status_to_dead_should_update_assigner_user

    auth = Auth.new @driver
    auth.login

    lead = Lead.new @driver, {:status => 'select Dead'}

    assert_equal lead.get('dead_status_assigner_c'), "David MZ"
    assert_equal lead.get('dead_status_assigned_date_c'), today_crm_date
  end
end