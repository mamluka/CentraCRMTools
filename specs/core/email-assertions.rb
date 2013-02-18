require 'json'
require 'mail'
require 'minitest/autorun'

class EmailAssertions
  def initialize
    config = JSON.parse(File.read(File.dirname(__FILE__) + "/email-config.json"))

    Mail.defaults do
      retriever_method :pop3, :address => config['host'],
                       :port => 995,
                       :user_name => config['username'],
                       :password => config['password'],
                       :enable_ssl => true
    end
  end

  def clear_inbox
    Mail.delete_all
  end
end