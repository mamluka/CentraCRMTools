require 'grape'
require 'json'

require_relative "../core/crm-database"

class CrmNotingApi2 < Grape::API
  resource :crmtools do
    get :one do
      "yeah sexy"
    end
  end
end