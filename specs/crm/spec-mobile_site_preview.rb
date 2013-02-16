require 'minitest/autorun'
require 'watir-webdriver'
require 'securerandom'

require File.dirname(__FILE__) + '/base/auth.rb'
require File.dirname(__FILE__) + '/base/lead.rb'
require File.dirname(__FILE__) + '/base/crm_test_base.rb'

class TestMini < CrmTestBase

  def test_when_has_preview_url_should_send_preview_email
    email = "#{SecureRandom.uuid}@david.com"

    lead = Lead.new @driver,
                    {:prev_url_c => 'http://preview.flowmobileapps.com/compare/testing',
                     :email => "email #{email}"
                    }

    assert_api_called({:email => email, :previewUrl => 'http://preview.flowmobileapps.com/compare/testing'})
    assert_includes lead.get('mobile_preview_email_sent_c'), today_crm_date
    assert_equal lead.status, "Assigned"
  end

  def test_when_has_no_preview_url_should_not_send_preview_email
    email = "#{SecureRandom.uuid}@david.com"

    lead = Lead.new @driver, {:email => "email #{email}"}

    assert_api_not_called
    assert_equal lead.status, ""
  end

  def test_when_has_no_email_should_not_send_preview_email
    lead = Lead.new @driver

    assert_api_not_called
    assert_equal lead.status, ""
  end
end
	




