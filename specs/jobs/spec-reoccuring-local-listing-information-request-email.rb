current_dir = File.dirname(__FILE__)

require current_dir + "/base/jobs-base.rb"

class Tests < JobsTestBase
  def test_when_3_days_passed_after_request_info_and_no_listing_information_should_update_sending_date

    lead = lead_with do |lead|
      lead.status = 'client'
    end

    lead.add_custom_data do |data|
      data.googlelocal_info_req_sent_c = 4.days.ago
    end

    load_job 'reoccuring-local-listing-information-request-email'

    result = lead.reload

    assert result.custom_data.googlelocal_info_req_sent_c > 5.minutes.ago
  end

  def test_when_3_days_passed_after_request_info_and_no_listing_information_should_send_enail

    lead = lead_with do |lead|
      lead.status = 'client'
    end

    lead.add_custom_data do |data|
      data.googlelocal_info_req_sent_c = 4.days.ago
    end

    load_job 'reoccuring-local-listing-information-request-email'

    assert_email_contains 'Centra will be personally taking care of your Local Listing top placement'
    assert_email_contains 'http://centracorporation.com/local-listing-customer-information#!' + lead.id
  end
end