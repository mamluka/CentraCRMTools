current_dir = File.dirname(__FILE__)

require current_dir + "/base/jobs-base.rb"



class CancellationSystemEmailTests < JobsTestBase
  def test_when_3_days_passed_from_cancellation_status_set_should_send_email

    lead = Lead.new
    lead.save

    lead.add_email "david@david.com"

    lead.add_custom_data do |data|
      data.cancellation_change_date_c = 4.days.ago
    end

    lead.save

    load_job 'cancellation-system-email'

  end
end
