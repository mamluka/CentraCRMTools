require_relative "base/jobs-base"


class Tests < JobsTestBase
  def test_when_status_is_dead_should_move_to_system_pipeline

    lead = lead_with do |lead|
      lead.status = 'Dead'
    end

    load_job 'move-dead-lead-to-system-pipeline'

    result = lead.reload

    assert_equal result.assigned_user_id, system_pipeline_user_id
  end

  def test_when_status_is_dead_should_add_note

    lead = lead_with do |lead|
      lead.status = 'Dead'
    end

    load_job 'move-dead-lead-to-system-pipeline'

    assert_note_added lead.id, "Moved to system pipeline because the lead is dead"
  end
end