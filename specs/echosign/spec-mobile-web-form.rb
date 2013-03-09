require_relative "base/echosign-base"

class LocalListingFormTests < EchoSignTestsBase
  def test_when_selling_mobile_web_should_send_out_agreement_and_update_the_fields

    lead = CrmLead.new @driver, {
        :status => 'select Client',
        :email => "email crmtesting@centracorporation.com",
        :mobileweb_check_c => 'check',
        :mobileweb_contract_type_c => 'select Centra 24'
    }

    contract_url = @email_client.get_first_email_body.match(/"(https:\/\/centra.echosign.com\/public\/esign.+?)"/).captures[0]

    @driver.goto contract_url

    fill_basic_info
    fill_billing_info
    not_same_billing_address
    fill_billing_address
    fill_client_details
    full_mobile_web_information
    fill_sign_details

    sign_form

    assert_price_point '24.99'

    sleep 3

    assert_equal lead.get_list('billing_payment_method_c'), 'Visa'

    assert !lead.is_checked('billing_same_address_c')

    assert_equal lead.get('billing_address_street_c'), 'billing address'
    assert_equal lead.get('billing_address_city_c'), 'billing city'
    assert_equal lead.get('billing_address_state_c'), 'New York'
    assert_equal lead.get('billing_address_zip_c'), '12345'

    assert_includes lead.get_by_label('Business Address'), 'address'
    assert_includes lead.get_by_label('Business Address'), 'city'
    assert_includes lead.get_by_label('Business Address'), 'Alabama'
    assert_includes lead.get_by_label('Business Address'), 'Alabama'
    assert_includes lead.get_by_label('Business Address'), '54321'

    assert_includes lead.get('service_area_c'), 'LA'

    assert_includes lead.get('host_dash_url_c'), 'http://hosting.com'
    assert_includes lead.get('host_login_c'), 'hosting_user'
    assert_includes lead.get('host_password_c'), 'hosting_password'

    assert_includes lead.get('domain_host_dash_url_c'), 'http://domain.com'
    assert_includes lead.get('domain_host_username_c'), 'provider_user'
    assert_includes lead.get('domain_host_password_c'), 'provider_password'

    assert lead.is_checked('mobileweb_echosign_signed_c')

    assert_includes lead.get('mobileweb_sign_date_c'), today_mysql_time
  end


  def test_when_selling_mobile_web_and_billing_address_is_the_same_should_send_out_agreement_and_update_the_fields

    lead = CrmLead.new @driver, {
        :status => 'select Client',
        :email => "email crmtesting@centracorporation.com",
        :mobileweb_check_c => 'check',
        :mobileweb_contract_type_c => 'select Centra 24'
    }

    contract_url = @email_client.get_first_email_body.match(/"(https:\/\/centra.echosign.com\/public\/esign.+?)"/).captures[0]

    @driver.goto contract_url

    fill_basic_info
    fill_billing_info

    same_billing_address
    fill_billing_address

    fill_client_details
    full_mobile_web_information

    fill_sign_details
    sign_form

    sleep 3

    assert_equal lead.get_list('billing_payment_method_c'), 'Visa'

    assert lead.is_checked('billing_same_address_c')

    assert_equal lead.get('billing_address_street_c'), 'address'
    assert_equal lead.get('billing_address_city_c'), 'city'
    assert_equal lead.get('billing_address_state_c'), 'Alabama'
    assert_equal lead.get('billing_address_zip_c'), '54321'

    assert_includes lead.get_by_label('Business Address'), 'address'
    assert_includes lead.get_by_label('Business Address'), 'city'
    assert_includes lead.get_by_label('Business Address'), 'Alabama'
    assert_includes lead.get_by_label('Business Address'), 'Alabama'
    assert_includes lead.get_by_label('Business Address'), '54321'

    assert_includes lead.get('service_area_c'), 'LA'

    assert_includes lead.get('host_dash_url_c'), 'http://hosting.com'
    assert_includes lead.get('host_login_c'), 'hosting_user'
    assert_includes lead.get('host_password_c'), 'hosting_password'

    assert_includes lead.get('domain_host_dash_url_c'), 'http://domain.com'
    assert_includes lead.get('domain_host_username_c'), 'provider_user'
    assert_includes lead.get('domain_host_password_c'), 'provider_password'

    assert lead.is_checked('mobileweb_echosign_signed_c')

    assert_includes lead.get('mobileweb_sign_date_c'), today_mysql_time
  end


  def full_mobile_web_information
    @driver.text_field(:name => 'hosting_url').set 'http://hosting.com'
    @driver.text_field(:name => 'hosting_username').set 'hosting_user'
    @driver.text_field(:name => 'hosting_password').set 'hosting_password'

    @driver.text_field(:name => 'domain_provider_url').set 'http://domain.com'
    @driver.text_field(:name => 'domain_provider_username').set 'provider_user'
    @driver.text_field(:name => 'domain_provider_password').set 'provider_password'
  end

  def sign_form
    @driver.execute_script("document.getElementById('document-frame').style.height='10000px'; document.getElementById('scrollable-wrapper').style.height='10000px'")
    @driver.element(:css => 'div[fieldname=echosign_signature] img').click
    @driver.text_field(:id => 'signature-name').when_present.set 'david mz'
    @driver.div(:id => 'adopt').click
    @driver.div(:id => 'submit').when_present.click
  end

  def fill_sign_details
    @driver.text_field(:name => 'company').set 'centra'
    @driver.text_field(:name => 'print_name').set 'centra ltd'
    @driver.text_field(:name => 'title').set 'CTO'
    @driver.text_field(:name => 'date').set '1/1/14'
  end

  def fill_client_details
    @driver.text_field(:name => 'alt_phone').set '0987654321'
    @driver.text_field(:name => 'name').set 'David the name'
    @driver.text_field(:name => 'website').set 'http://www.centracorporation.com'
    @driver.text_field(:name => 'address').set 'address'
    @driver.text_field(:name => 'city').set 'city'
    @driver.select_list(:name => 'state').select 'Alabama'
    @driver.text_field(:name => 'zip').set '54321'
    @driver.text_field(:name => 'service_area').set 'LA'
  end

  def same_billing_address
    @driver.radio(:value => 'same_address').set
  end

  def not_same_billing_address
    @driver.radio(:value => 'not_same_address').set
  end

  def fill_billing_address


    @driver.text_field(:name => 'billing_address').set 'billing address'
    @driver.text_field(:name => 'billing_city').set 'billing city'
    @driver.select_list(:name => 'billing_state').select 'New York'
    @driver.text_field(:name => 'billing_zip').set '12345'
  end

  def fill_billing_info
    @driver.radio(:value => 'visa').set

    @driver.text_field(:name => 'billing_cc_number').set '1234567890'
    @driver.text_field(:name => 'billing_cc_exp').set '03/16'
    @driver.text_field(:name => 'billing_cc_ccv').set '123'
    @driver.text_field(:name => 'billing_cc_name').set 'David mz card'
  end

  def fill_basic_info
    @driver.text_field(:name => 'contact_name').set 'David mz'
    @driver.text_field(:name => 'contact_email').set 'david.mazvovsky@gmail.com'
    @driver.text_field(:name => 'contact_phone').set '1234567890'
  end
end