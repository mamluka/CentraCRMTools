require 'grape'
require 'json'

require_relative 'echosign'
require_relative 'lead-form'

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

        echosign.send params[:email], params[:contractId], config['callback_url']
      rescue => exception
        exception.message
      end
    end

    get :notify do
      if params[:eventType] == "ESIGNED"
        document_key = params[:documentKey]

        echosign = EchoSign.new
        csv_hash = echosign.get_form_data document_key

        lead_form = LeadForm.new csv_hash
        lead_form.update_crm document_key
      end
    end

    get 'document-list' do
      echosign = EchoSign.new
      echosign.get_documents.select { |x| x[:display_user_info][:full_name_or_email] == "Reusable Document" }
    end
  end

end
