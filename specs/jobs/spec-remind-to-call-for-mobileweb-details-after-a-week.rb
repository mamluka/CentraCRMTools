current_dir = File.dirname(__FILE__)

require current_dir + "/base/jobs-base.rb"

class Tests < JobsTestBase
  def test_when_3_days_passed_after_request_info_and_no_mobileweb_info_should_update_sending_date

    lead = lead_with do |lead|
      lead.status = 'client'
    end

    lead.add_custom_data do |data|
      data.mobileweb_sale_date_c = 7.days.ago
      data.mobileweb_check_c = true
    end

    load_job 'remind-to-call-for-mobileweb-details-after-a-week'

    result = lead.reload

    assert result.custom_data.mobileweb_info_req_sent_c > 5.minutes.ago
  end
end