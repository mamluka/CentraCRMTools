current_dir = File.dirname(__FILE__)

require current_dir + "/base/jobs-base.rb"


class Tests < JobsTestBase
  def test_when_7_days_passed_from_assigned_status_should_move_to_system_pipeline

    lead = lead_with do |lead|
      lead.date_entered = 8.days.ago
      lead.status = 'FU'
    end

    lead.add_custom_data do |data|
      data.prev_url_c = 'http://david.com'
    end

    load_job 'move-assigned-leads-to-system-pipeline'

    result = lead.reload

    assert_equal result.status, "SP"
    assert_equal result.assigned_user_id, system_pipeline_user_id
  end

  def test_when_user_has_mobile_preview_url_and_7_days_passed_should_update_email_sending_date

    lead = lead_with do |lead|
      lead.date_entered = 8.days.ago
      lead.status = 'FU'
    end

    lead.add_custom_data do |data|
      data.prev_url_c = 'http://david.com'
    end

    load_job 'move-assigned-leads-to-system-pipeline'

    result = lead.reload

    assert result.custom_data.system_pipeline_email_1_c > 5.minutes.ago
  end

  def test_when_user_has_mobile_preview_url_and_7_days_passed_should_send_system_pipeline_email_one

    lead = lead_with do |lead|
      lead.date_entered = 8.days.ago
      lead.status = 'FU'
    end

    lead.add_custom_data do |data|
      data.prev_url_c = 'http://david.com'
    end

    load_job 'move-assigned-leads-to-system-pipeline'

    assert_email_contains 'This past week we attempted to deliver and host your mobile website.'
    assert_email_contains 'http://david.com'
  end
end