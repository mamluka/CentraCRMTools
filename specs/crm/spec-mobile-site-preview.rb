require 'minitest/autorun'
require 'watir-webdriver'
require 'securerandom'

require_relative 'base/crm-test-base.rb'

class TestMini < CrmTestBase

  def test_when_has_preview_url_should_update_sending_date
    email = "#{SecureRandom.uuid}@david.com"

    lead = CrmLead.new @driver,
                       {:prev_url_c => 'http://preview.flowmobileapps.com/compare/testing',
                        :email => "email #{email}"
                       }

    assert_includes lead.get('mobile_preview_email_sent_c'), today_crm_date
    assert_equal lead.status, "Assigned"
  end

  def test_when_has_preview_url_should_send_preview_email

    CrmLead.new @driver,
                {:prev_url_c => 'http://preview.flowmobileapps.com/compare/testing',
                 :email => "email crmtesting@centracorporation.com"
                }

    assert_email_contains 'At this stage we consider it 80% done.'
    assert_email_contains 'http://preview.flowmobileapps.com/compare/testing'


  end

  def test_when_has_preview_url_should_add_note

    lead = CrmLead.new @driver,
                       {:prev_url_c => 'http://preview.flowmobileapps.com/compare/testing',
                        :email => "email crmtesting@centracorporation.com"
                       }

    assert_note_added lead.id, "Site preview was sent to crmtesting@centracorporation.com"

  end

  def test_when_has_no_preview_url_should_not_send_preview_email
    email = "#{SecureRandom.uuid}@david.com"

    lead = CrmLead.new @driver, {:email => "email #{email}"}

    assert_email_not_sent
    assert_equal lead.status, ""
  end

  def test_when_has_no_email_should_not_send_preview_email
    lead = CrmLead.new @driver

    assert_email_not_sent
    assert_equal lead.status, ""
  end
end
	




