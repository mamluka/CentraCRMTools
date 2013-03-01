require_relative "../core/crm-database"

class LocalListing

  def initialize(csv_hash)
    @csv_hash = csv_hash
  end

  def update_crm(document_id)

    db = CrmDatabase.new
    db.connect

    custom_data = CustomData.where(:echosign_doc_id_c => document_id).first
    lead = custom_data.lead

    puts @csv_hash

    puts @csv_hash.class

    puts @csv_hash["billing_payment_options"]

    custom_data.billing_payment_method_c = @csv_hash['billing_payment_options']

    if @csv_hash['billing_payment_options'] == "not_same_address"
      custom_data.billing_address_street_c = @csv_hash['billing_address']
      custom_data.billing_address_city_c = @csv_hash['billing_city']
      custom_data.billing_address_state_c = @csv_hash['billing_state']
      custom_data.billing_address_zip_c = @csv_hash['billing_zip']
    else
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

    opening_hours = @csv_hash.map { |k, v| k.split('_').last.upcase! + ' - ' + v }
    regular_opening_hours = opening_hours.select { |s| s.include?('Sat') || s.include?('Sun') }

    custom_data.business_hours_mf_c = (opening_hours - regular_opening_hours).join(', ')
    custom_data.business_hours_ss_c = regular_opening_hours.join(', ')

    custom_data.business_payment_types_c = @csv_hash.select { |k, v| k.includes?('payment_type') && v == "Yes" }.map { |s| s.plit('_').last.upper! }.join(', ')

    custom_data.save

  end
end