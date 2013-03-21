require_relative "base/echosign-base"
require 'rest-client'

class FromEmailTests < EchoSignTestsBase

  def test_when_called_sending_endpoint_with_existing_lead_should_send_out_email
    lead = Lead.new

    lead.first_name = "david"
    lead.add_email "crmtesting@centracorporation.com"
    lead.save

    RestClient.get 'http://soa.centracorporation.com:9050/api/echosign/sign-me-up', {:params => {
        :id => lead.id,
        :title => 'Mobile Web Presence Discount'
    }}

    subject = @email_client.get_first_email_subject

    assert_includes subject, 'Mobile Web Presence Discount'
  end

end