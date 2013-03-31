require 'grape'
require 'json'

require_relative "../../core/databases"

class CrmNotingApi < Grape::API
  post :note do
    id = params[:id]
    message = params[:message]
    description = params[:description]

    db = Databases.new
    db.connect

    Note.add id, message, description
  end
end