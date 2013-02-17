current_dir = File.dirname(__FILE__)

require current_dir + "/base/jobs-base.rb"


class Tests < JobsTestBase
  def test_when_status_is_dead_should_move_to_system_pipeline

    lead = lead_with do |lead|
      lead.status = 'Dead'
    end

    puts lead.custom_data

    load_job 'move-dead-lead-to-system-pipeline'

    result = lead.reload

    assert_equal result.assigned_user_id, $system_pipeline_user_id
    assert result.custom_date.dead_status_assigned_date_c > 5.minutes.ago
  end
end