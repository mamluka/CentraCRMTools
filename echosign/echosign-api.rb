require 'grape'
require 'json'

require_relative 'echosign'
require_relative 'local-listing-form'

class EchoSignApi < Grape::API
  format :json

  helpers do
    def get_config
      JSON.parse(File.read(File.dirname(__FILE__) + "/config.json"))
    end
  end

  resource :echosign do
    get :send do
      begin
        config = get_config
        echosign = EchoSign.new

        echosign.send params[:email], "RWKW8L232Y3Z7F", config['callback_url']
      rescue => exception
        exception.message
      end
    end

    get :notify do
      if params[:eventType] == "ESIGNED"
        document_key = params[:documentKey]

        echosign = EchoSign.new
        csv_hash = echosign.get_form_data document_key

        local_listing = LocalListing.new csv_hash
        local_listing.update_crm document_key
      end
    end
  end
end