current_dir = File.dirname(__FILE__)

require current_dir + "/base/jobs-base.rb"


class DeadSystemEmailTests < JobsTestBase
  def test_when_7_days_passed_from_dead_status_set_should_send_email

    lead = lead_with do |lead|
      lead.status = 'Dead'
      lead.assigned_user_id = $system_pipeline_user_id
    end

    lead.add_custom_data do |data|
      data.dead_status_assigned_date_c = 10.days.ago
    end

    load_job 'dead-lead-system-email'

    result = lead.reload

    assert_includes result.custom_data.cancellation_email_sent_c.to_s, today_crm_time
  end
end