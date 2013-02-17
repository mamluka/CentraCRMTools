current_dir = File.dirname(__FILE__)

require current_dir + "/base/jobs-base.rb"

class Tests < JobsTestBase
  def test_when_3_days_passed_after_request_info_and_no_listing_information_should_send_enail

    lead = lead_with do |lead|
      lead.status = 'client'
    end

    lead.add_custom_data do |data|
      data.mobileweb_info_req_sent_c = 4.days.ago
    end

    load_job 'reoccuring-local-listing-information-request-email'

    result = lead.reload

    assert_includes result.custom_data.mobileweb_info_req_sent_c, today_crm_time
  end
end