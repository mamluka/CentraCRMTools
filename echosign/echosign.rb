require 'savon'
require 'json'

class EchoSign

  def initialize
    config = JSON.parse File.read(File.dirname(__FILE__) + "/echosign.json")
    @api_key = config['apikey']

    @client = Savon.client do
      wsdl "https://centra.echosign.com/services/EchoSignDocumentService15?wsdl"
      ssl_verify_mode :none
    end
  end

  def send(email)
    response = call :send_document, {
        :apiKey => @api_key,
        :senderInfo => nil,
        :documentCreationInfo => {
            :recipients => {:RecipientInfo => {:email => email, :role => 'SIGNER', :fax => nil}},
            :name => 'test agreement',
            :message => 'this is a test message',
            :fileInfos => {:fileInfo => {
                :fileName => 'Centra Coproration Centra Local Listing Contract ver 2',
                :libraryDocumentKey => 'RWKW8L232Y3Z7F',
                :mimeType => nil,
                :file => nil,
                :url => nil,
                :formKey => nil,
                :libraryDocumentName => nil
            }},
            :signatureType => 'ESIGN',
            :signatureFlow => 'SENDER_SIGNATURE_NOT_REQUIRED',
            :securityOptions => nil,
            :externalId => nil,
            :reminderFrequency => nil,
            :callbackInfo => nil,
            :daysUntilSigningDeadline => nil,
            :locale => nil,
            :mergeFieldInfo => nil
        }
    }

    puts response

  end

  private

  def call(resource, params)
    #params = params.merge :apiKey => @api_key

    @client.call resource, :message => params
  end

end