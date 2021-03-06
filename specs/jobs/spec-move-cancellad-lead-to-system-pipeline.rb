current_dir = File.dirname(__FILE__)

require current_dir + "/base/jobs-base.rb"


class Tests < JobsTestBase
  def test_when_status_is_cancelled_should_move_to_system_pipeline

    lead = lead_with do |lead|
      lead.status = 'cancelled'
    end

    load_job 'move-cancellad-lead-to-system-pipeline'

    result = lead.reload

    assert result.custom_data.cancellation_change_date_c > 5.minutes.ago
    assert_equal result.assigned_user_id, system_pipeline_user_id
  end

  def test_when_status_is_cancelled_should_add_note

    lead = lead_with do |lead|
      lead.status = 'cancelled'
    end

    load_job 'move-cancellad-lead-to-system-pipeline'

    assert_note_added lead.id, "Moved to System pipeline because was cancelled"

  end
end