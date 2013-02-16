require 'minitest/autorun'
require 'watir-webdriver'

require File.dirname(__FILE__) + '/base/auth.rb'
require File.dirname(__FILE__) + '/base/lead.rb'
require File.dirname(__FILE__) + '/base/crm_test_base.rb'

class TestMini < CrmTestBase
  def test_when_change_status_to_cancelled_should_update_assigner_user

    lead = Lead.new @driver, {
        :status => 'select Cancelled',
        :assigned_user_name => 'Paul J. Antonitis'
    }

    assert_equal lead.get('cancelling_rep_c'), "David MZ"
    assert_includes lead.get('original_rep_c'), 'Paul J. Antonitis'
  end
end