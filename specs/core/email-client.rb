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
    puts "Clearing inbox"
    Mail.delete_all

  end

  def get_first_email_body

    number_of_emails = wait_for_emails
    if number_of_emails == 0
      return ""
    end

    mail = Mail.all.first

    if mail.multipart?
      mail.part[0].body
    else
      mail.body
    end
  end

  def wait_for_emails
    time_elapsed = 0
    while Mail.all.length == 0 && time_elapsed < 30
      sleep 5
      time_elapsed +=5
    end

    Mail.all.length
  end
end