current_dir = File.dirname(__FILE__)

require current_dir + "/base/jobs-base.rb"


class CancellationSystemEmailTests < JobsTestBase
  def test_when_3_days_passed_from_cancellation_status_set_should_send_email

    lead = lead_with do |lead|
      lead.status = 'cancelled'
    end

    lead.add_custom_data do |data|
      data.cancellation_change_date_c = 4.days.ago
    end

    lead.save

    load_job 'cancellation-system-email'

    result = lead.reload

    assert_includes result.custom_data.cancellation_email_sent_c.to_s, today_crm_time
  end

  def test_when_2_days_passed_from_cancellation_status_should_not_send_email

    lead = lead_with do |lead|
      lead.status = 'cancelled'
    end

    lead.add_custom_data do |data|
      data.cancellation_change_date_c = 2.days.ago
    end

    lead.save

    load_job 'cancellation-system-email'

    result = lead.reload

    assert_nil result.custom_data.cancellation_email_sent_c
  end
end
