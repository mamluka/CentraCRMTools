current_dir = File.dirname(__FILE__)

require current_dir + "/base/jobs-base.rb"

class Tests < JobsTestBase
  def test_7_days_pass_after_local_listing_data_varified_send_out_reminder_to_fill_in_google_verification_code

    lead = lead_with do |lead|
      lead.status = 'Client'
    end

    lead.add_custom_data do |data|
      data.googlelocal_check_c = true
      data.googlelocal_verified_c = true
    end

    load_job 'remind-to-fill-in-local-listing-verification-code'

    assert_email_contains 'By now you should have received the correspondence from Google.'
    assert_email_contains 'http://centracorporation.com/google-local-listing-code#!' + lead.id
  end
end