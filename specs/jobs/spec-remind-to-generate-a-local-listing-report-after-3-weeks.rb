require_relative "base/jobs-base.rb"

class Tests < JobsTestBase
  def test_when_3_weeks_passed_after_contract_signed_remind_to_send_report

    lead = lead_with do |lead|
      lead.status = 'client'
    end

    lead.add_custom_data do |data|
      data.googlelocal_sign_date_c = 22.days.ago
    end

    load_job 'spec-remind-to-generate-a-local-listing-report-after-3-weeks'

    assert_email_contains "3 Weeks passed it's time to send a report to this client"
  end

  def test_when_3_weeks_passed_after_contract_signed_and_report_was_send_do_npt_remind_again

    lead = lead_with do |lead|
      lead.status = 'client'
    end

    lead.add_custom_data do |data|
      data.googlelocal_sign_date_c = 30.days.ago
      data.googlelocal_report_sent_date_c = 2.days.ago
    end

    load_job 'spec-remind-to-generate-a-local-listing-report-after-3-weeks'

    assert_email_not_sent
  end
end