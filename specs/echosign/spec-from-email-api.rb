require_relative "base/echosign-base"
require 'rest-client'

class FromEmailTests < TestsBase

  def test_when_called_sending_endpoint_with_existing_lead_should_send_out_email

    lead = Lead.new

    lead.first_name = "david"
    lead.add_email "crmtesting@centracorporation.com"
    lead.add_custom_data

    lead.save

    wait_for_api
    RestClient.get 'http://soa.centracorporation.com:9050/api/echosign/sign-me-up', {:params => {
        :id => lead.id,
        :title => 'Mobile Web Presence Discount'
    }}

    result = lead.reload

    subject = @email_client.get_first_email_subject

    assert_includes subject, 'Mobile Web Presence Discount'

    assert result.custom_data.googlelocal_echosign_in_c
    refute result.custom_data.echosign_doc_id_c.empty?

  end

  def test_when_called_sending_endpoint_and_contact_id_already_exist_should_tell_you
    lead = Lead.new

    lead.first_name = "david"
    lead.add_email "crmtesting@centracorporation.com"

    lead.add_custom_data do |data|
      data.echosign_doc_id_c = "xxx"
    end

    lead.save

    wait_for_api
    result = RestClient.get 'http://soa.centracorporation.com:9050/api/echosign/sign-me-up', {:params => {
        :id => lead.id,
        :title => 'Mobile Web Presence Discount'
    }}

    assert_includes result, "Contract was already sent"
  end

  def test_when_called_sending_endpoint_with_and_lead_doesnt_exist_should_raise_error

    wait_for_api
    result = RestClient.get 'http://soa.centracorporation.com:9050/api/echosign/sign-me-up', {:params => {
        :id => 'xxxx',
        :title => 'Mobile Web Presence Discount'
    }}

    assert_includes result, "No such lead"

  end

end