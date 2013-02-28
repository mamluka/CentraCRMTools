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

    custom_data.billing_payment_method_c = @csv_hash['billing_payment_options']
    custom_data.billing_same_address_c = @csv_hash['billing_same_address']
    custom_data.billing_address_street_c = @csv_hash['billing_address']
    custom_data.billing_address_city_c = @csv_hash['billing_city']
    custom_data.billing_address_state_c = @csv_hash['billing_state']
    custom_data.billing_address_zip_c = @csv_hash['billing_zip']

    lead.phone_other = @csv_hash['alt_phone']
    lead.primary_address_street = @csv_hash['address']
    lead.primary_address_city= @csv_hash['city']
    lead.primary_address_state= @csv_hash['state']
    lead.primary_address_postalcode = @csv_hash['zip']

    custom_data.billing_address_zip_c = @csv_hash['billing_zip']


  end
end