current_dir = File.dirname(__FILE__)

require current_dir + "/base/jobs-base.rb"
require current_dir + "/../../jobs/lib/init.rb"
require current_dir + "/../../jobs/lib/active_records_models.rb"


class CancellationSystemEmailTests < JobsTestBase
  def test_when_3_days_passed_from_cancellation_status_set_should_send_email
    reload_database

    lead = Lead.new

    email = Email.new
    email.email_address = "test@test.com"
    lead.emails << email

    custom_data = CustomData.new
    custom_data.cancellation_change_date_c = 4.days.ago
    lead.custom_data = custom_data

    lead.save

  end
end