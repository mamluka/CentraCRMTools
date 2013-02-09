require 'rest_client'

class ApiEmailer
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

  def email(api, email, more = nil)
    apiCallParams = {:email => email}
    if not more.nil?
      apiCallParams = apiCallParams.merge(more)
    end

    puts apiCallParams.to_s

    RestClient.get "http://apps.centracorporation.com/api/email/#{api}", {:params => apiCallParams}
  end

end