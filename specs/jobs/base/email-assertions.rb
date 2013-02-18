require 'json'
require 'mail'

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

  end
end