require 'grape'
require 'json'
require 'logger'

require_relative 'echosign'
require_relative 'lead-form'

class EchoSignApi < Grape::API
  format :txt

  helpers do
    def get_config
      JSON.parse(File.read(File.dirname(__FILE__) + "/echosign.json"))
    end

    def get_documents
      JSON.parse(File.read(File.dirname(__FILE__)+"/documents-metadata.json.db"))
    end

    def send_contract(contract_id, contract_title, email)
      config = get_config
      echosign = EchoSign.new

      echosign.send email, contract_id, config['callback_url'], contract_title
    end

    def contract_title_by_id(contract_id)
      documents = get_documents
      documents.select { |doc| doc['id'] == contract_id }.first['title']
    end

    def contract_id_by_title(contract_title)
      documents = get_documents
      documents.select { |doc| doc['title'] == contract_title }.first['id']
    end
  end

  get :send do
    begin
      contract_title = contract_title_by_id params[:contractId]
      send_contract params[:contractId], contract_title, params[:email]

    rescue Exception => exception
      Logger.new('echosign.log').error exception.message
      'Error'
    end
  end

  get '/sign-me-up' do
    begin

      lead_id = params[:id]

      return "No such lead" unless Lead.exists?(:id => lead_id)

      lead = Lead.find(lead_id)

      return "Contract was already sent" unless lead.custom_data.echosign_doc_id_c.nil?

      contract_title = params[:title]
      contract_id = contract_id_by_title contract_title

      sent_contract_id = send_contract contract_id, contract_title, lead.email
      lead.add_custom_data do |data|
        data.echosign_doc_id_c = sent_contract_id
      end

      lead.save

    rescue => exception
      exception.message
    end
  end

  get :notify do

    begin
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

      if params[:eventType] == "EMAIL_VIEWED"

        document_key = params[:documentKey]
        lead_form = LeadForm.new
        lead_form.mark_as_viewed document_key

      end

    rescue => exception
      exception.message
    end
  end

  get 'document-list' do
    echosign = EchoSign.new
    echosign.get_documents.select { |x| x[:display_user_info][:full_name_or_email] == "Reusable Document" }.map { |x| {name: x[:name], document_key: x[:document_key]} }
  end

  get 'document-list-full' do
    echosign = EchoSign.new
    echosign.get_documents
  end

  get 'document-list-clean' do
    echosign = EchoSign.new
    keys = echosign.get_documents.select { |x| x[:display_user_info][:full_name_or_email].to_s.include?('david.com') || x[:display_user_info][:full_name_or_email].to_s == "crmtesting@centracorporation.com" }.map { |x| x[:document_key] }
    keys.each do |key|
      echosign.cancel_document key
    end
  end

  get 'send-from-test-user' do
    contract_title = contract_title_by_id params[:contractId]

    config = get_config
    echosign = EchoSign.new

    echosign.send_from_test_user params[:email], params[:contractId], config['callback_url'], contract_title
  end


end
