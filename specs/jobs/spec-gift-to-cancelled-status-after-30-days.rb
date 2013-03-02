require_relative "base/jobs-base.rb"

class Tests < JobsTestBase
  def test_30_days_after_cancel_status_send_out_gift_email

    lead = lead_with do |lead|
      lead.status = 'cancelled'
    end

    lead.add_custom_data do |data|
      data.cancellation_change_date_c = 30.days.ago
    end

    load_job 'gift-to-cancelled-status-after-30-days'

    result = lead.reload

    assert_email_contains 'At a certain level we assume responsibility for this taking place'
    assert_email_contains 'http://centracorporation.com/gift#!' + result.custom_data.gift_widget_document_id_c
  end
end