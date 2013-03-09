require 'date'
require_relative "../core/crm-database"

class LeadForm

  def initialize(csv_hash)
    @csv_hash = csv_hash
  end

  def update_crm(document_id)

    db = CrmDatabase.new
    db.connect

    custom_data = CustomData.where(:echosign_doc_id_c => document_id).first
    lead = custom_data.lead

    custom_data.billing_payment_method_c = @csv_hash['billing_payment_options'].capitalize

    if @csv_hash['billing_same_address'] == "not_same_address"
      custom_data.billing_same_address_c = false

      custom_data.billing_address_street_c = @csv_hash['billing_address']
      custom_data.billing_address_city_c = @csv_hash['billing_city']
      custom_data.billing_address_state_c = @csv_hash['billing_state']
      custom_data.billing_address_zip_c = @csv_hash['billing_zip']

    else
      custom_data.billing_same_address_c = true

      custom_data.billing_address_street_c = @csv_hash['address']
      custom_data.billing_address_city_c = @csv_hash['city']
      custom_data.billing_address_state_c = @csv_hash['state']
      custom_data.billing_address_zip_c = @csv_hash['zip']
    end

    custom_data.billing_cc_number_c = @csv_hash['billing_cc_number']
    custom_data.billing_cc_exp_date_c = @csv_hash['billing_cc_exp']
    custom_data.billing_cc_cvv_c = @csv_hash['billing_cc_ccv']
    custom_data.billing_cc_name_c = @csv_hash['billing_cc_name']

    lead.phone_other = @csv_hash['alt_phone']
    lead.primary_address_street = @csv_hash['address']
    lead.primary_address_city= @csv_hash['city']
    lead.primary_address_state= @csv_hash['state']
    lead.primary_address_postalcode = @csv_hash['zip']

    custom_data.service_area_c = @csv_hash['service_area']
    custom_data.business_category_c = @csv_hash.select { |k| k.start_with?('category') }.values.join(', ')

    opening_hours = @csv_hash.select { |k| k.include?('opening_hours') }.map { |k, v| k.split('_').last.capitalize + ': ' + v }
    regular_opening_hours = opening_hours.select { |s| !s.include?('Sat') && !s.include?('Sun') }

    custom_data.business_hours_mf_c = regular_opening_hours.join(', ')
    custom_data.business_hours_ss_c = (opening_hours - regular_opening_hours).join(', ')

    custom_data.business_payment_types_c = @csv_hash.select { |k, v| k.include?('payment_type') && v == "Yes" }.keys.map { |s| s.split('_').last.capitalize }.join(', ')

    custom_data.host_dash_url_c=@csv_hash['hosting_url']
    custom_data.host_login_c=@csv_hash['hosting_username']
    custom_data.host_password_c=@csv_hash['hosting_password']

    custom_data.domain_host_dash_url_c=@csv_hash['domain_provider_url']
    custom_data.domain_host_username_c=@csv_hash['domain_provider_username']
    custom_data.domain_host_password_c=@csv_hash['domain_provider_password']


    custom_data.googlelocal_sign_date_c = Time.now
    custom_data.googlelocal_echosign_signed_c = true

    custom_data.save

  end
end