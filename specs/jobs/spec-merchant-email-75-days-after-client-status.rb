require_relative "base/jobs-base.rb"

class Tests < JobsTestBase
  def test_30_days_after_dead_status_send_out_gift_email

    skip()

    lead_with do |lead|
      lead.status = 'client'
    end

    lead.add_custom_data do |data|
      data.merch_check_c = false
    end

    load_job 'merchant-email-75-days-after-client-status'

    assert_email_contains 'We wanted to drop by and thank you again for the opportunity to doing business'
  end
end