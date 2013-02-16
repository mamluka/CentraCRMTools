require 'minitest/autorun'
require 'watir-webdriver'
require 'securerandom'

require File.dirname(__FILE__) + '/base/auth.rb'
require File.dirname(__FILE__) + '/base/lead.rb'
require File.dirname(__FILE__) + '/base/crm_test_base.rb'

class TestMini < CrmTestBase

  def test_when_google_local_listing_is_sold_should_send_email_and_update_dates
    auth = Auth.new @driver
    auth.login

    email = "#{SecureRandom.uuid}@david.com"

    lead = Lead.new @driver, {
        :status => 'select Client',
        :mobileweb_check_c => 'check',
        :email => "email #{email}"
    }

    first_name = lead.get 'first_name'

    assert_api_called({'email' => email, 'name' => first_name, 'customerId' => lead.id})

    assert_equal lead.get('mobileweb_info_req_sent_c'), today_crm_date
    assert_equal lead.get('mobileweb_sale_date_c'), today_crm_date
    assert_equal lead.get('mobileweb_sale_rep_c'), 'David MZ'
  end

end


