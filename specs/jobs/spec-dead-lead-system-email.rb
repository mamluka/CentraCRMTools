current_dir = File.dirname(__FILE__)

require current_dir + "/base/jobs-base.rb"


class Tests < JobsTestBase
  def test_when_7_days_passed_from_dead_status_set_should_update_fields

    lead = lead_with do |lead|
      lead.status = 'Dead'
      lead.assigned_user_id = system_pipeline_user_id
    end

    lead.add_custom_data do |data|
      data.dead_status_assigned_date_c = 10.days.ago
    end

    load_job 'dead-lead-system-email'

    result = lead.reload

    assert result.custom_data.dead_client_email_sent_c > 5.minutes.ago
  end

  def test_when_7_days_passed_from_dead_status_set_should_send_email

    lead = lead_with do |lead|
      lead.status = 'Dead'
      lead.assigned_user_id = system_pipeline_user_id
    end

    lead.add_custom_data do |data|
      data.dead_status_assigned_date_c = 10.days.ago
    end

    load_job 'dead-lead-system-email'

    assert_email_contains 'wants to reach back out'

  end

  def test_when_4_days_passed_from_dead_status_set_should_not_send_email

    lead = lead_with do |lead|
      lead.status = 'Dead'
      lead.assigned_user_id = system_pipeline_user_id
    end

    lead.add_custom_data do |data|
      data.dead_status_assigned_date_c = 4.days.ago
    end

    load_job 'dead-lead-system-email'

    result = lead.reload

    assert_nil result.custom_data.dead_client_email_sent_c
  end

  def test_when_dead_status_and_not_billable_should_not_send_email

    lead = lead_with do |lead|
      lead.status = 'Dead'
      lead.assigned_user_id = system_pipeline_user_id
    end

    lead.add_custom_data do |data|
      data.dead_status_assigned_date_c = 4.days.ago
      data.not_billable_c = true
    end

    load_job 'dead-lead-system-email'

    result = lead.reload

    assert_nil result.custom_data.dead_client_email_sent_c
  end
end