current_dir = File.dirname(__FILE__)

require current_dir + "/base/jobs-base.rb"


class Tests < JobsTestBase
  def test_when_status_is_client_should_move_him_to_centra_small_business_user

    lead = lead_with do |lead|
      lead.status = 'client'
    end

    load_job 'move-client-lead-to-centra-small-business'

    result = lead.reload

    assert_equal result.assigned_user_id, $centra_small_business_user_id
  end
end