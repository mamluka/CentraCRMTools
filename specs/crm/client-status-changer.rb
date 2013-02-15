require 'minitest/autorun'
require 'watir-webdriver'

require File.dirname(__FILE__) + '/base/auth.rb'
require File.dirname(__FILE__) + '/base/lead.rb'
require File.dirname(__FILE__) + '/base/crm_test_base.rb'

class TestMini < CrmTestBase
  def test_when_change_status_to_client_should_update_assigner_user

    auth = Auth.new @driver
    auth.login

    lead = Lead.new @driver, {:status => 'select Client', :mobileweb_check_c => 'check'}

    assert_equal lead.get('rep_client_status_changed_c'), "David MZ"
    assert_includes lead.get('client_status_change_date_c'), today_crm_date
  end
end