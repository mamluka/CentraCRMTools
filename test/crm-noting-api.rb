require 'grape'
require 'json'

require_relative "../core/crm-database"

class CrmNotingApi < Grape::API
  resource :crmtools do
    post :two do
      "yeah two sexy"
    end
  end
end