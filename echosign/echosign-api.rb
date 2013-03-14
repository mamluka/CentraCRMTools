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

        contract_id = params[:contractId]

        document_title = config['documents'].select { |doc| doc['id'] == contract_id }.first['title']

        echosign.send params[:email], contract_id, config['callback_url'], document_title
      rescue => exception
        exception.message
      end
    end

    get :notify do
      if params[:eventType] == "ESIGNED"
        document_key = params[:documentKey]
        echosign = EchoSign.new
        info = echosign.get_document_info document_key

        csv_hash = echosign.get_form_data document_key

        lead_form = LeadForm.new
        lead_form.update_crm csv_hash, document_key, info[:name]
      end

      if params[:eventType] == "SIGNATURE_REQUESTED"

        document_key = params[:documentKey]
        echosign = EchoSign.new
        info = echosign.get_document_info document_key

        lead_form = LeadForm.new
        lead_form.mark_as_requested document_key, info[:name]

      end
    end

    get 'document-list' do
      echosign = EchoSign.new
      echosign.get_documents.select { |x| x[:display_user_info][:full_name_or_email] == "Reusable Document" }
    end
  end

end
