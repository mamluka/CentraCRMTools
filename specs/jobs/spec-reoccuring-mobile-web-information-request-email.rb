current_dir = File.dirname(__FILE__)

require current_dir + "/base/jobs-base.rb"

class Tests < JobsTestBase
  def test_when_3_days_passed_after_request_info_and_no_mobileweb_info_should_send_enail

    lead = lead_with do |lead|
      lead.status = 'client'
    end

    lead.add_custom_data do |data|
      data.googlelocal_info_req_sent_c = 4.days.ago
    end

    load_job 'move-do-not-email-lead-to-dead-status'

    result = lead.reload

    assert_includes result.custom_data.googlelocal_info_req_sent_c, today_crm_time
  end
end