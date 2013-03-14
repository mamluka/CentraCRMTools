require 'grape'
require 'json'

require_relative "../core/crm-database"

class Crm2ExcelApi < Grape::API
  resource :crmtools do
    post :note do
      id = params[:id]

      db = CrmDatabase.new
      db.connect

    end
  end
end