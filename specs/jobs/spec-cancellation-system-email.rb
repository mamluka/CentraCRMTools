current_dir = File.dirname(__FILE__)

require current_dir + "/base/jobs-base.rb"


class CancellationSystemEmailTests < JobsTestBase
  def test_when_3_days_passed_from_cancellation_status_set_should_send_email

    lead = Lead.new
    lead.status = 'cancelled'
    lead.save

    lead.add_email "crmtesting@centracorporation.com"

    lead.add_custom_data do |data|
      data.cancellation_change_date_c = 4.days.ago
    end

    lead.save

    puts !lead.custom_data.nil?
    puts lead.custom_data.cancellation_change_date_c < 3.days.ago
    puts lead.emails.any?
    puts !lead.do_not_email
    puts lead.custom_data.cancellation_email_sent_c.nil?

    load_job 'cancellation-system-email'
  end
end
