require_relative "base/echosign-base"

class LocalListingFormTests < EchoSignTestsBase
  def test_when_selling_local_listing_99_price_point_should_send_out_agreement_and_update_the_fields

    lead = CrmLead.new @driver, {
        :status => 'select Client',
        :email => "email crmtesting@centracorporation.com",
        :googlelocal_check_c => 'check',
        :googlelocal_contract_type_c => 'select Centra 99'
    }

    contract_url = @email_client.get_first_email_body.match(/"(https:\/\/centra.echosign.com\/public\/esign.+?)"/).captures[0]

    @driver.goto contract_url

    assert_price_point '99'

    fill_basic_info
    fill_billing_info

    not_same_billing_address
    fill_billing_address

    fill_client_details
    fill_categories
    fill_working_hours
    fill_payment_types
    full_mobile_web_information

    fill_sign_details
    sign_form


    sleep 3

    assert !lead.is_checked('billing_same_address_c')

    assert_billing_address_when_not_the_same(lead)
    assert_client_details(lead)
    assert_google_local_details(lead)
    assert_mobile_web_details(lead)
    assert_signing(lead)

    end

  def test_when_selling_local_listing_79_price_point_should_send_out_agreement_and_update_the_fields

    lead = CrmLead.new @driver, {
        :status => 'select Client',
        :email => "email crmtesting@centracorporation.com",
        :googlelocal_check_c => 'check',
        :googlelocal_contract_type_c => 'select Centra 80'
    }

    contract_url = @email_client.get_first_email_body.match(/"(https:\/\/centra.echosign.com\/public\/esign.+?)"/).captures[0]

    @driver.goto contract_url

    fill_basic_info
    fill_billing_info

    not_same_billing_address
    fill_billing_address

    fill_client_details
    fill_categories
    fill_working_hours
    fill_payment_types
    full_mobile_web_information

    fill_sign_details
    sign_form

    assert_price_point '79.99'

    sleep 3

    assert !lead.is_checked('billing_same_address_c')

    assert_billing_address_when_not_the_same(lead)
    assert_client_details(lead)
    assert_google_local_details(lead)
    assert_mobile_web_details(lead)
    assert_signing(lead)

  end

  def test_when_selling_local_listing_and_billing_address_is_the_same_should_send_out_agreement_and_update_the_fields

    lead = CrmLead.new @driver, {
        :status => 'select Client',
        :email => "email crmtesting@centracorporation.com",
        :googlelocal_check_c => 'check',
        :googlelocal_contract_type_c => 'select Centra 99'
    }

    contract_url = @email_client.get_first_email_body.match(/"(https:\/\/centra.echosign.com\/public\/esign.+?)"/).captures[0]

    @driver.goto contract_url

    fill_basic_info
    fill_billing_info

    same_billing_address

    fill_client_details
    fill_categories
    fill_working_hours
    fill_payment_types
    full_mobile_web_information

    fill_sign_details
    sign_form

    sleep 3

    assert lead.is_checked('billing_same_address_c')

    assert_billing_address_when_same(lead)
    assert_client_details(lead)
    assert_google_local_details(lead)
    assert_mobile_web_details(lead)
    assert_signing(lead)
  end

  def assert_signing(lead)
    assert lead.is_checked('googlelocal_echosign_signed_c')
    assert_includes lead.get('googlelocal_sign_date_c'), today_crm_date
  end

  def assert_mobile_web_details(lead)
    assert_includes lead.get('host_dash_url_c'), 'http://hosting.com'
    assert_includes lead.get('host_login_c'), 'hosting_user'
    assert_includes lead.get('host_password_c'), 'hosting_password'

    assert_includes lead.get('domain_host_dash_url_c'), 'http://domain.com'
    assert_includes lead.get('domain_host_username_c'), 'provider_user'
    assert_includes lead.get('domain_host_password_c'), 'provider_password'
  end

  def assert_google_local_details(lead)
    assert_includes lead.get('business_category_c'), 'cat1'
    assert_includes lead.get('business_category_c'), 'cat2'
    assert_includes lead.get('business_category_c'), 'cat3'
    assert_includes lead.get('business_category_c'), 'cat4'
    assert_includes lead.get('business_category_c'), 'cat5'

    assert_includes lead.get('business_hours_mf_c'), '1-2'
    assert_includes lead.get('business_hours_mf_c'), '2-3'
    assert_includes lead.get('business_hours_mf_c'), '3-4'
    assert_includes lead.get('business_hours_mf_c'), '4-5'
    assert_includes lead.get('business_hours_mf_c'), '5-6'

    assert_includes lead.get('business_hours_ss_c'), '6-7'
    assert_includes lead.get('business_hours_ss_c'), '7-8'

    assert_includes lead.get('business_payment_types_c'), 'Check'
    assert_includes lead.get('business_payment_types_c'), 'Cash'
    assert_includes lead.get('business_payment_types_c'), 'Visa'
    assert_includes lead.get('business_payment_types_c'), 'Mastercard'
    assert_includes lead.get('business_payment_types_c'), 'Discover'
    assert_includes lead.get('business_payment_types_c'), 'Amex'
    assert_includes lead.get('business_payment_types_c'), 'Paypal'
    assert_includes lead.get('business_payment_types_c'), 'Google'
    assert_includes lead.get('business_payment_types_c'), 'Financing'
    assert_includes lead.get('business_payment_types_c'), 'Invoice'
    assert_includes lead.get('business_payment_types_c'), 'Diners'
  end

  def assert_client_details(lead)
    assert_includes lead.get_by_label('Business Address'), 'address'
    assert_includes lead.get_by_label('Business Address'), 'city'
    assert_includes lead.get_by_label('Business Address'), 'Alabama'
    assert_includes lead.get_by_label('Business Address'), '54321'

    assert_includes lead.get('service_area_c'), 'LA'
  end

  def assert_billing_address_when_not_the_same(lead)
    assert_equal lead.get_list('billing_payment_method_c'), 'Visa'
    assert_equal lead.get('billing_address_street_c'), 'billing address'
    assert_equal lead.get('billing_address_city_c'), 'billing city'
    assert_equal lead.get('billing_address_state_c'), 'New York'
    assert_equal lead.get('billing_address_zip_c'), '12345'
  end

  def assert_billing_address_when_same(lead)
    assert_equal lead.get_list('billing_payment_method_c'), 'Visa'
    assert_equal lead.get('billing_address_street_c'), 'address'
    assert_equal lead.get('billing_address_city_c'), 'city'
    assert_equal lead.get('billing_address_state_c'), 'Alabama'
    assert_equal lead.get('billing_address_zip_c'), '54321'
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

  def fill_payment_types
    @driver.checkbox(:name => 'payment_type_check').set
    @driver.checkbox(:name => 'payment_type_cash').set
    @driver.checkbox(:name => 'payment_type_visa').set
    @driver.checkbox(:name => 'payment_type_mastercard').set
    @driver.checkbox(:name => 'payment_type_discover').set
    @driver.checkbox(:name => 'payment_type_amex').set
    @driver.checkbox(:name => 'payment_type_paypal').set
    @driver.checkbox(:name => 'payment_type_google').set
    @driver.checkbox(:name => 'payment_type_financing').set
    @driver.checkbox(:name => 'payment_type_invoice').set
    @driver.checkbox(:name => 'payment_type_diners').set
  end

  def fill_working_hours
    @driver.text_field(:name => 'opening_hours_mon').set '1-2'
    @driver.text_field(:name => 'opening_hours_tue').set '2-3'
    @driver.text_field(:name => 'opening_hours_wed').set '3-4'
    @driver.text_field(:name => 'opening_hours_thu').set '4-5'
    @driver.text_field(:name => 'opening_hours_fri').set '5-6'
    @driver.text_field(:name => 'opening_hours_sat').set '6-7'
    @driver.text_field(:name => 'opening_hours_sun').set '7-8'
  end

  def fill_categories
    @driver.text_field(:name => 'category1').set 'cat1'
    @driver.text_field(:name => 'category2').set 'cat2'
    @driver.text_field(:name => 'category3').set 'cat3'
    @driver.text_field(:name => 'category4').set 'cat4'
    @driver.text_field(:name => 'category5').set 'cat5'
  end

  def fill_client_details
    @driver.text_field(:name => 'phone').set '1234567890'
    @driver.text_field(:name => 'alt_phone').set '0987654321'
    @driver.text_field(:name => 'name').set 'David the name'
    @driver.text_field(:name => 'website').set 'http://www.centracorporation.com'
    @driver.text_field(:name => 'email').set 'david@centracorporation.com'
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