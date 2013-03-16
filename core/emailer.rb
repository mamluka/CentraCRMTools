require 'rest_client'

class ApiEmailer

  def initialize
    @config = JSON.parse(File.read(File.dirname(__FILE__) + "/config.json"))
  end

  def first_system_pipeline(email, previewUrl)
    email 'first-system-pipeline', email, {:previewUrl => previewUrl}
  end

  def second_system_pipeline(email, previewUrl)
    email 'second-system-pipeline', email, {:previewUrl => previewUrl}
  end

  def cancellation(email)
    email 'cancellation', email
  end

  def dead_client(email)
    email 'dead-client', email
  end

  def mobileweb_info_request(email, name, customerId)
    email 'mobile-site-client-information-request', email, {:name => name, :customerId => customerId}
  end

  def googlelocal_info_request(email, name, customerId)
    email 'google-local-listing-client-information-request', email, {:name => name, :customerId => customerId}
  end

  def google_local_listing_verification_reminder(email, customerId)
    email 'google-local-listing-verification-reminder', email, {:customerId => customerId}
  end

  def local_listing_system_message(subject, message)

    to = @config['localListingEmail']

    mail = Mail.new do
      from 'service@centracorporation.com'
      to to
      subject subject
      body message
    end

    deliver_local_emails mail

  end

  def deliver_local_emails(mail)
    mail.delivery_method :smtp, {:address => @config['host'],
                                 :port => 25,
                                 :user_name => @config['username'],
                                 :password => @config['password'],
                                 :authentication => 'plain'}

    mail.deliver
  end

  def email(api, email, more = nil)
    api_call_params = {:email => email}

    unless more.nil?
      api_call_params = api_call_params.merge(more)
    end

    RestClient.get "#{@config["centraAppsApiBaseUrl"]}/email/#{api}", {:params => api_call_params}
  end

end