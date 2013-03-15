require 'grape'
require 'json'

require_relative "../core/crm-database"

class CrmNotingApi < Grape::API
  resource :crmtools do
    post :note do
      id = params[:id]
      message = params[:message]
      description = params[:description]

      db = CrmDatabase.new
      db.connect

      Note.add id, message, description
    end
  end
end