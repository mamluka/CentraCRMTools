require_relative "base/echosign-base"

class LocalListingFormTests < EchoSignTestsBase
  def test_when_selling_local_listing_should_send_out_agreement_and_update_the_fields

    lead = Lead.new @driver, {
        :status => 'select Client',
        :email => "email crmtesting@centracorporation.com",
        :googlelocal_check_c => 'check'
    }

    contract_url = @email_client.get_first_email_body.match(/"(https:\/\/centra.echosign.com\/public\/esign.+?)"/).captures[0]

    puts contract_url

    @driver.goto contract_url

    @driver.text_field(:name => 'contact_name').set 'David mz'
    @driver.text_field(:name => 'contact_email').set 'david.mazvovsky@gmail.com'
    @driver.text_field(:name => 'contact_phone').set '1234567890'

    @driver.radio(:value => 'visa').set

    @driver.radio(:name, 'billing_same_address', "0").set
    @driver.text_field(:name => 'billing_address').set 'billing address'
    @driver.text_field(:name => 'billing_city').set 'billing city'
    @driver.select_list(:name => 'billing_state').select 'New York'
    @driver.text_field(:name => 'billing_zip').set '12345'

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

    @driver.text_field(:name => 'category1').set 'cat1'
    @driver.text_field(:name => 'category2').set 'cat2'
    @driver.text_field(:name => 'category3').set 'cat3'
    @driver.text_field(:name => 'category4').set 'cat4'
    @driver.text_field(:name => 'category5').set 'cat5'

    @driver.text_field(:name => 'opening_hours_mon').set '1-2'
    @driver.text_field(:name => 'opening_hours_tue').set '2-3'
    @driver.text_field(:name => 'opening_hours_wed').set '3-4'
    @driver.text_field(:name => 'opening_hours_thu').set '4-5'
    @driver.text_field(:name => 'opening_hours_fri').set '5-6'
    @driver.text_field(:name => 'opening_hours_sat').set '6-7'
    @driver.text_field(:name => 'opening_hours_sun').set '7-8'

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

    @driver.text_field(:name => 'company').set 'centra'
    @driver.text_field(:name => 'print_name').set 'centra ltd'
    @driver.text_field(:name => 'signature').set 'centra signature'
    @driver.text_field(:name => 'title').set 'CTO'
    @driver.text_field(:name => 'date').set '1/1/2014'

    @driver.div(:css => 'div[fieldname=echosign_signature]').click

    @driver.text_field(:id => 'signature-name').when_present.set 'david mz'
    @driver.div(:id => 'adopt').click

    @driver.div(:id => 'submit').when_present.click

    assert_equal lead.get('billing_payment_method_c'), 'Visa'

    #TODO checking the same billing checkbox is missing

    assert_equal lead.get('billing_payment_method_c'), 'Visa'
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

    assert_equal lead.get('googlelocal_sign_date_c'), today_crm_time

  end
end