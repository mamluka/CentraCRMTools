require File.dirname(__FILE__) + "/email-assertions.rb"

class TestsBase < MiniTest::Unit::TestCase

  def setup
    @email_assertions = EmailAssertions.new
    @email_assertions.clear_inbox
  end

  def teardown
    @email_assertions.clear_inbox
  end

  def today_crm_time
    Time.now.strftime('%Y-%m-%d %H:%M')
  end

  def today_crm_date
    Date.today.strftime('%m/%d/%Y')
  end

  def assert_email_contains(text)
    time_elapsed = 0
    while Mail.all.length == 0 && time_elapsed < 30
      sleep 5
      time_elapsed +=5
    end

    if Mail.all.length == 0
      flunk "No email found"
    end

    assert_includes Mail.first.parts.first.body, text
  end
end