require 'virgola'

require_relative "../core/crm-database"

class LocalListing
  include Virgola

  attribute :completed
  attribute :email
  attribute :role
  attribute :first
  attribute :last
  attribute :title
  attribute :company
  attribute :address
  attribute :alt_phone
  attribute :billing_address
  attribute :billing_cc_ccv
  attribute :billing_cc_exp
  attribute :billing_cc_name
  attribute :billing_cc_number
  attribute :billing_city
  attribute :billing_payment_options
  attribute :billing_same_address
  attribute :billing_state
  attribute :billing_zip
  attribute :category5
  attribute :category1
  attribute :category2
  attribute :category3
  attribute :category4
  attribute :city
  attribute :contact_email
  attribute :contact_name
  attribute :contact_phone
  attribute :date
  attribute :name
  attribute :opening_hours_fri
  attribute :opening_hours_mon
  attribute :opening_hours_sat
  attribute :opening_hours_sun
  attribute :opening_hours_thu
  attribute :opening_hours_tue
  attribute :opening_hours_wed
  attribute :payment_type_amex
  attribute :payment_type_cash
  attribute :payment_type_check
  attribute :payment_type_diners
  attribute :payment_type_discover
  attribute :payment_type_financing
  attribute :payment_type_google
  attribute :payment_type_invoice
  attribute :payment_type_mastercard
  attribute :payment_type_paypal
  attribute :payment_type_visa
  attribute :phone
  attribute :print_name
  attribute :service_area
  attribute :signature
  attribute :state
  attribute :website
  attribute :zip

  def update_crm(document_id)

    db = CrmDatabase.new
    db.connect

    lead_id = CustomData.where(:echosign_doc_id => document_id).id

    lead = Lead.find(lead_id)



  end
end