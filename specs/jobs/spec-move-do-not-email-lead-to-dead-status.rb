current_dir = File.dirname(__FILE__)

require current_dir + "/base/jobs-base.rb"

class Tests < JobsTestBase
  def test_when_lead_is_do_not_email_should_move_to_dead_status

    lead = lead_with do |lead|
      lead.status = 'FU'
    end

    lead.add_custom_data do |data|
      data.do_not_email_c = true
    end

    load_job 'move-do-not-email-lead-to-dead-status'

    result = lead.reload

    assert_equal result.status, 'Dead'
    assert_equal result.assigned_user_id, system_pipeline_user_id
    assert_equal result.custom_data.dead_status_assigner_c, 'System Pipeline'
  end

  def test_when_lead_is_do_not_email_should_add_note

    lead = lead_with do |lead|
      lead.status = 'FU'
    end

    lead.add_custom_data do |data|
      data.do_not_email_c = true
    end

    load_job 'move-do-not-email-lead-to-dead-status'

    assert_note_added lead.id, "Moved to dead because lead has no email"
  end
end