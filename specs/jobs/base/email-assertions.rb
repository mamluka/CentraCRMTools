require 'json'
require 'mail'
require 'minitest/autorun'

class EmailAssertions
  def initialize
    config = JSON.parse(File.dirname(__FILE__) + "/email-config.json")
    Mail.defaults do
      retriever_method :pop3, :address => config['host'],
                       :port => 995,
                       :user_name => config['username'],
                       :password => config['password'],
                       :enable_ssl => true
    end
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

  def clear_inbox
    Mail.delete_all
  end
end