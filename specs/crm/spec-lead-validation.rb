require 'minitest/autorun'
require 'watir-webdriver'

require_relative 'base/crm-test-base.rb'

class TestMini < CrmTestBase

  def test_when_changed_to_client_status_should_validate_sold_services
    CrmLead.new @driver, {:status => 'select Client'}

    assert_equal @driver.text, "You can't change a lead to client status without setting the centra service he purchased first, it is located in the Sold Services tab"
  end

  def test_when_change_to_cancelled_status_and_mobileweb_is_checked_should_not_allow_to_save
    CrmLead.new @driver, {:mobileweb_check_c => 'check', :status => 'select Cancelled'}

    assert_equal @driver.text, "You can't change a lead to cancelled status when you have service checked, the services are located in the Sold Services tab"

  end

  def test_when_change_to_cancelled_status_and_local_listing_is_checked_should_not_allow_to_save
    CrmLead.new @driver, {:googlelocal_check_c => 'check', :status => 'select Cancelled'}

    assert_equal @driver.text, "You can't change a lead to cancelled status when you have service checked, the services are located in the Sold Services tab"

  end

  def test_when_change_to_cancelled_status_and_marchent_is_checked_should_not_allow_to_save
    CrmLead.new @driver, {:merch_check_c => 'check', :status => 'select Cancelled'}

    assert_equal @driver.text, "You can't change a lead to cancelled status when you have service checked, the services are located in the Sold Services tab"

  end

  def test_when_set_non_billable_should_have_a_reason_selected
    CrmLead.new @driver, {:not_billable_c => 'check'}

    assert_equal @driver.text, "Non billable must have a reason"

  end

end