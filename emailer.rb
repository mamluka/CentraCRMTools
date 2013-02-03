require 'rest_client'

class ApiEmailer
  def first_system_pipeline(email, previewUrl)
    email 'first-system-pipeline', email, {:previewUrl => previewUrl}
  end

  def second_system_pipeline(email, previewUrl)
    email 'second-system-pipeline', email, {:previewUrl => previewUrl}
  end

  def email(api, email, more = nil)
    apiCallParams = {:email => email}
    if not more.nil?
      apiCallParams.merge(more)
    end
    RestClient.get "http://apps.centracorporation.com/api/email/#{api}", {:params => apiCallParams}
  end

  def cancellation(email)
    email 'cancellation', email
  end

  def dead_client(email)
    email 'dead-client', email
  end
end