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

  def email(api, email, more = nil)
    apiCallParams = {:email => email}
    if not more.nil?
      apiCallParams = apiCallParams.merge(more)
    end

    RestClient.get "#{@config["CentraAppsApiBaseUrl"]}/email/#{api}", {:params => apiCallParams}
  end
end