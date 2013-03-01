require 'grape'
require 'json'

require_relative 'echosign'
require_relative 'local-listing-form'

class EchoSignApi < Grape::API
  format :json

  resource :echosign do
    get :send do
      begin
        echosign = EchoSign.new
        echosign.send params[:email], "RWKW8L232Y3Z7F", @@config['callback_url']
      rescue
        "ERROR"
      end
    end

    get :notify do
      document_key = params[:documentKey]

      csv_hash = @echosign.get_form_data :document_key

      local_listing = LocalListing.new csv_hash
      local_listing.update_crm document_key

    end
  end

  def get_config
    JSON.parse(File.read(File.dirname(__FILE__) + "/config.json"))
  end

end