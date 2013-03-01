require_relative "base/jobs-base.rb"

class Tests < JobsTestBase
  def test_30_days_after_dead_status_send_out_gift_email

    lead_with do |lead|
      lead.status = 'Dead'
    end

    lead.add_custom_data do |data|
      data.dead_status_assigned_date_c = 30.days.ago
    end

    load_job 'gift-to-dead-status-after-30-days'

    result = lead.reload

    assert_email_contains 'we take a level a responsibly for not providing you with a working relationship'
    assert_email_contains 'http://centracorporation.com/gift#!' + result.custom_data.gift_widget_document_id_c
  end
end