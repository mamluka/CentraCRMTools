require 'minitest/autorun'
require 'watir-webdriver'

require File.dirname(__FILE__) + '/base/auth.rb'
require File.dirname(__FILE__) + '/base/lead.rb'
require File.dirname(__FILE__) + '/base/crm_test_base.rb'

class TestMini < CrmTestBase
  def test_when_non_billable_and_reason_is_invalid_url_should_send_out_email_and_update_status_and_dates

    email = "#{SecureRandom.uuid}@david.com"

    lead = Lead.new driver, {
        :email => "email #{email}",
        :not_billable_c => 'check',
        :non_billable_reason_c => 'select Invalid url'
    }

    assert_api_called({:email => email, :customerId => lead.id})

    assert_includes lead.get('not_billable_assign_date_c'), today_crm_date
    assert_includes lead.get('not_billable_assigner_c'), 'David MZ'
    assert_includes lead.status, 'Pit stop'
  end

  def test_when_non_billable_and_reason_not_business_owner_should_send_out_email_and_update_status_and_dates

    email = "#{SecureRandom.uuid}@david.com"

    lead = Lead.new driver, {
        :email => "email #{email}",
        :not_billable_c => 'check',
        :non_billable_reason_c => 'select Not business owner or decision maker'
    }

    assert_api_called({:email => email, :customerId => lead.id})

    assert_includes lead.get('not_billable_assign_date_c'), today_crm_date
    assert_includes lead.get('not_billable_assigner_c'), 'David MZ'
    assert_includes lead.status, 'Dead'
  end

  def test_when_non_billable_and_reason_not_intrested_should_send_out_email_and_update_status_and_dates

    email = "#{SecureRandom.uuid}@david.com"

    lead = Lead.new driver, {
        :email => "email #{email}",
        :not_billable_c => 'check',
        :non_billable_reason_c => 'select Not interested'
    }

    assert_includes lead.get('not_billable_assign_date_c'), today_crm_date
    assert_includes lead.get('not_billable_assigner_c'), 'David MZ'
    assert_includes lead.status, 'Dead'
  end


end