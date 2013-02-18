current_dir = File.dirname(__FILE__)

require current_dir + "/base/jobs-base.rb"

class Tests < JobsTestBase
  def test_when_3_days_passed_after_request_info_and_no_mobileweb_info_should_update_sending_date

    lead = lead_with do |lead|
      lead.status = 'client'
    end

    lead.add_custom_data do |data|
      data.mobileweb_info_req_sent_c = 4.days.ago
    end

    load_job 'reoccuring-mobile-web-information-request-email'

    result = lead.reload

    assert result.custom_data.mobileweb_info_req_sent_c > 5.minutes.ago
  end

  def test_when_3_days_passed_after_request_info_and_no_mobileweb_info_should_send_enail

    lead = lead_with do |lead|
      lead.status = 'client'
    end

    lead.add_custom_data do |data|
      data.mobileweb_info_req_sent_c = 4.days.ago
    end

    load_job 'reoccuring-mobile-web-information-request-email'

    assert_email_contains 'Centra will be personally taking care of your mobile website implementation'
    assert_email_contains 'http://centracorporation.com/mobile-site-customer-information#!' + lead.id

  end
end