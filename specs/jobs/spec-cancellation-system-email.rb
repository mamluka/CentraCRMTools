require_relative "base/jobs-base.rb"

class Tests < JobsTestBase
  def test_when_3_days_passed_from_cancellation_status_set_should_update_fields

    lead = lead_with do |lead|
      lead.status = 'cancelled'
    end

    lead.add_custom_data do |data|
      data.cancellation_change_date_c = 4.days.ago
    end

    load_job 'cancellation-system-email'

    result = lead.reload

    assert result.custom_data.cancellation_email_sent_c > 5.minutes.ago
  end

  def test_when_3_days_passed_from_cancellation_status_set_should_send_email

    lead = lead_with do |lead|
      lead.status = 'cancelled'
    end

    lead.add_custom_data do |data|
      data.cancellation_change_date_c = 4.days.ago
    end

    load_job 'cancellation-system-email'

    assert_email_contains 'We know you had to recently stop all Centra services for your business'

  end

  def test_when_3_days_passed_from_cancellation_status_set_should_add_note

    lead = lead_with do |lead|
      lead.status = 'cancelled'
    end

    lead.add_custom_data do |data|
      data.cancellation_change_date_c = 4.days.ago
    end

    load_job 'cancellation-system-email'

    assert_note_added lead.id, "Cancellation email was sent 3 days after status was set to cancelled"
  end

  def test_when_2_days_passed_from_cancellation_status_should_not_send_email

    lead = lead_with do |lead|
      lead.status = 'cancelled'
    end

    lead.add_custom_data do |data|
      data.cancellation_change_date_c = 2.days.ago
    end

    load_job 'cancellation-system-email'

    result = lead.reload

    assert_nil result.custom_data.cancellation_email_sent_c
  end
end
