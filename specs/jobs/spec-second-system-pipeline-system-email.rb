current_dir = File.dirname(__FILE__)

require current_dir + "/base/jobs-base.rb"

class Tests < JobsTestBase
  def test_when_7_days_passed_after_first_system_email_should_send_the_second_email

    lead = lead_with do |lead|
      lead.status = 'SP'
      lead.assigned_user_id = $system_pipeline_user_id
    end

    lead.add_custom_data do |data|
      data.system_pipeline_email_1_c = 10.days.ago
      data.prev_url_c = "http://prevurl"
    end

    load_job 'second-system-pipeline-system-email'

    result = lead.reload

    assert result.custom_data.system_pipeline_email_2_c > 5.minutes.ago
  end
end