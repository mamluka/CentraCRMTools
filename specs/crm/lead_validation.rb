require 'minitest/autorun'
require 'watir-webdriver'

require File.dirname(__FILE__) + '/base/auth.rb'
require File.dirname(__FILE__) + '/base/lead.rb'
require File.dirname(__FILE__) + '/base/crm_test_base.rb'

class TestMini < CrmTestBase

  def test_when_changed_to_client_status_should_validate_sold_services
    Lead.new @driver, {:status => 'select Client'}

    assert_equal @driver.text, "You can't change a lead to client status without setting the centra service he purchased first, it is located in the Sold Services tab"
  end

  def test_when_change_to_cancelled_status_and_mobileweb_is_checked_should_not_allow_to_save
    Lead.new @driver, {:mobileweb_check_c => 'check', :status => 'select Cancelled'}

    assert_equal @driver.text, "You can't change a lead to cancelled status when you have service checked, the services are located in the Sold Services tab"

  end

  def test_when_change_to_cancelled_status_and_local_listing_is_checked_should_not_allow_to_save
    Lead.new @driver, {:googlelocal_check_c => 'check', :status => 'select Cancelled'}

    assert_equal @driver.text, "You can't change a lead to cancelled status when you have service checked, the services are located in the Sold Services tab"

  end

  def test_when_change_to_cancelled_status_and_marchent_is_checked_should_not_allow_to_save
    Lead.new @driver, {:merch_check_c => 'check', :status => 'select Cancelled'}

    assert_equal @driver.text, "You can't change a lead to cancelled status when you have service checked, the services are located in the Sold Services tab"

  end

end