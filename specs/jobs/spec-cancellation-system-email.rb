current_dir = File.dirname(__FILE__)

require current_dir + "/base/jobs-base.rb"
require current_dir + "/../../jobs/lib/init.rb"
require current_dir + "/../../jobs/lib/active_records_models.rb"


class CancellationSystemEmailTests < JobsTestBase
  def test_when_3_days_passed_from_cancellation_status_set_should_send_email
    reload_database

    lead = Lead.new
    puts lead.id
    lead.save

    lead.add_email "david@david.com"

    lead.add_custom_data do |data|
      data.cancellation_change_date_c = 4.days.ago
    end

    lead.save

  end
end
