require 'minitest/autorun'
require 'watir-webdriver'
require 'securerandom'

require_relative 'base/crm-test-base.rb'

class TestMini < CrmTestBase

  def test_when_mobile_web_is_sold_should_update_dates
    email = "#{SecureRandom.uuid}@david.com"

    lead = CrmLead.new @driver, {
        :status => 'select Client',
        :mobileweb_check_c => 'check',
        :email => "email #{email}"
    }

    assert_equal lead.get('mobileweb_info_req_sent_c'), today_crm_date
    assert_equal lead.get('mobileweb_sale_date_c'), today_crm_date
    assert_equal lead.get('mobileweb_sale_rep_c'), 'David MZ'
  end

  def test_when_mobile_web_is_sold_should_send_email

    enable_email_sending

    lead = CrmLead.new @driver, {
        :status => 'select Client',
        :mobileweb_check_c => 'check',
        :email => "email crmtesting@centracorporation.com",
    }

    first_name = lead.get 'first_name'

    assert_email_contains 'Centra will be personally taking care of your mobile website implementation.'
    assert_email_contains 'http://centracorporation.com/mobile-site-customer-information#!' + lead.id
    assert_email_contains first_name

  end

  def test_when_mobile_web_is_sold_and_sales_date_already_exists_should_not_send_email
    email = "#{SecureRandom.uuid}@david.com"

    CrmLead.new @driver, {
        :status => 'select Client',
        :mobileweb_sale_date_c => today_crm_date,
        :mobileweb_check_c => 'check',
        :email => "email #{email}"
    }

    assert_email_not_sent
  end

  def test_when_google_local_listing_is_sold_should_update_dates
    email = "#{SecureRandom.uuid}@david.com"

    lead = CrmLead.new @driver, {
        :status => 'select Client',
        :googlelocal_check_c => 'check',
        :email => "email #{email}"
    }

    assert_equal lead.get('googlelocal_sale_date_c'), today_crm_date
    assert_equal lead.get('googlelocal_sale_rep_c'), 'David MZ'
  end

  def test_when_marchent_is_sold_should_update_dates
    email = "#{SecureRandom.uuid}@david.com"

    lead = CrmLead.new @driver, {
        :status => 'select Client',
        :merch_check_c => 'check',
        :email => "email #{email}"
    }

    assert_equal lead.get('marchent_sale_date_c'), today_crm_date
    assert_equal lead.get('marchent_sale_rep_c'), 'David MZ'
  end

end


