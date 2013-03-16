current_dir = File.dirname(__FILE__)

require current_dir + "/base/jobs-base.rb"

class Tests < JobsTestBase
  def test_when_3_days_passed_after_request_info_and_no_mobileweb_info_should_update_sending_date

    lead = lead_with do |lead|
      lead.status = 'client'
    end

    lead.add_custom_data do |data|
      data.mobileweb_info_req_sent_c = 4.days.ago
      data.mobileweb_check_c = true
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
      data.mobileweb_check_c = true
    end

    load_job 'reoccuring-mobile-web-information-request-email'

    assert_email_contains 'Centra will be personally taking care of your mobile website implementation'
    assert_email_contains 'http://centracorporation.com/mobile-site-customer-information#!' + lead.id

  end

  def test_when_3_days_passed_after_request_info_and_no_mobileweb_info_should_add_note

    lead = lead_with do |lead|
      lead.status = 'client'
    end

    lead.add_custom_data do |data|
      data.mobileweb_info_req_sent_c = 4.days.ago
      data.mobileweb_check_c = true
    end

    load_job 'reoccuring-mobile-web-information-request-email'

    assert_note_added lead.id, "Sent a mobile web hosting provider details request"
  end

  def test_when_mobile_web_is_not_sold_should_do_nothing

    lead = lead_with do |lead|
      lead.status = 'client'
    end

    lead.add_custom_data do |data|
      data.mobileweb_check_c = false
    end

    load_job 'reoccuring-mobile-web-information-request-email'

    result = lead.reload

    assert_nil result.custom_data.mobileweb_info_req_sent_c

  end
end