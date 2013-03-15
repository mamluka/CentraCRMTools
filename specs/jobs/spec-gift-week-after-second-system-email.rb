require_relative "base/jobs-base.rb"

class Tests < JobsTestBase
  def test_week_after_second_system_email_send_out_gift_email

    skip()

    lead = lead_with do |lead|
      lead.status = 'SP'
    end

    lead.add_custom_data do |data|
      data.system_pipeline_email_2_c = 7.days.ago
    end

    load_job 'gift-week-after-second-system-email'

    result = lead.reload

    assert_email_contains 'We want to Manage you Google Placement'
    assert_email_contains 'http://centracorporation.com/gift#!' + result.custom_data.gift_widget_document_id_c
  end
end