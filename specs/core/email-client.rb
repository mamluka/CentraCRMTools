require 'json'
require 'mail'
require 'minitest/autorun'

class EmailClient
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

  def get_first_email_body
    mail = Mail.all.first

    if mail.multipart?
      mail.part[0].body
    else
      mail.body
    end
  end
end