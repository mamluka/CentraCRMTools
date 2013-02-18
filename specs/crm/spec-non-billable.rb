require 'minitest/autorun'
require 'watir-webdriver'

require File.dirname(__FILE__) + '/base/auth.rb'
require File.dirname(__FILE__) + '/base/lead.rb'
require File.dirname(__FILE__) + '/base/crm_test_base.rb'

class TestMini < CrmTestBase
  def test_when_non_billable_and_reason_is_invalid_url_should_update_status_and_dates

    email = "#{SecureRandom.uuid}@david.com"

    lead = Lead.new @driver, {
        :email => "email #{email}",
        :not_billable_c => 'check',
        :non_billable_reason_c => 'select Invalid url'
    }

    assert_api_called({:email => email, :customerId => lead.id})

    assert_includes lead.get('not_billable_assign_date_c'), today_crm_date
    assert_includes lead.get('not_billable_assigner_c'), 'David MZ'
    assert_includes lead.status, 'Pit stop'
  end

  def test_when_non_billable_and_reason_is_invalid_url_should_send_out_an_email

    email = "#{SecureRandom.uuid}@david.com"

    lead = Lead.new @driver, {
        :email => "email #{email}",
        :not_billable_c => 'check',
        :non_billable_reason_c => 'select Invalid url'
    }

    assert_email_contains 'Thank you for your interest in the free mobile website conversion for your business.'
    assert_email_contains 'http://www.centracorporation.com/update-url#!' + lead.id


  end

  def test_when_non_billable_and_reason_not_business_owner_should_send_out_email

    Lead.new @driver, {
        :email => "email crmtesting@centracorporation.com",
        :not_billable_c => 'check',
        :non_billable_reason_c => 'select Not business owner or decision maker'
    }

    assert_email_contains 'Centra Small Business wants to make sure this information can make it to the appropriate party.'

  end

  def test_when_non_billable_and_reason_not_business_owner_should_update_sending_date

    lead = Lead.new @driver, {
        :email => "email crmtesting@centracorporation.com",
        :not_billable_c => 'check',
        :non_billable_reason_c => 'select Not business owner or decision maker'
    }

    assert_api_called({:email => email})

    assert_includes lead.get('not_billable_assign_date_c'), today_crm_date
    assert_includes lead.get('not_billable_assigner_c'), 'David MZ'
    assert_includes lead.status, 'Dead'
  end

  def test_when_non_billable_and_reason_not_intrested_should_update_status_and_dates

    email = "#{SecureRandom.uuid}@david.com"

    lead = Lead.new @driver, {
        :email => "email #{email}",
        :not_billable_c => 'check',
        :non_billable_reason_c => 'select Not interested'
    }

    assert_includes lead.get('not_billable_assign_date_c'), today_crm_date
    assert_includes lead.get('not_billable_assigner_c'), 'David MZ'
    assert_includes lead.status, 'Dead'
  end

  def test_when_non_billable_and_reason_invalid_email_update_status_and_dates

    email = "#{SecureRandom.uuid}@david.com"

    lead = Lead.new @driver, {
        :email => "email #{email}",
        :not_billable_c => 'check',
        :non_billable_reason_c => 'select Invalid email'
    }

    assert_includes lead.get('not_billable_assign_date_c'), today_crm_date
    assert_includes lead.get('not_billable_assigner_c'), 'David MZ'
    assert_includes lead.status, 'Pit stop'
  end


end