require 'savon'
require 'json'
require 'csv'

class RecipientInfo
  def initialize(email)
    @email = email
  end

  def to_s
    %q{<ins8:recipientInfo>
      <ins8:email>#{@email}</ins8:email>
      <ins8:role>SIGNER</ins8:role>
      <ins8:fax xsi:nil="true"/>
    </ins8:recipientInfo>}
  end
end

class FileInfo
  def initialize(filename, document_id)

    @filename = filename
    @document_id = document_id
  end

  def to_s
    %q{<ins0:fileInfo>
        <ins0:fileName>#{@filename}</ins0:fileName>
        <ins0:libraryDocumentKey>#{@document_id}</ins0:libraryDocumentKey>
        <ins0:mimeType xsi:nil="true"/>
        <ins0:file xsi:nil="true"/>
        <ins0:url xsi:nil="true"/>
        <ins0:formKey xsi:nil="true"/>
        <ins0:libraryDocumentName xsi:nil="true"/>
    </ins0:fileInfo>}
  end
end

class EchoSign

  def initialize
    config = JSON.parse File.read(File.dirname(__FILE__) + "/echosign.json")
    @api_key = config['apikey']

    @client = Savon.client do
      wsdl "https://centra.echosign.com/services/EchoSignDocumentService15?wsdl"
      ssl_verify_mode :none
    end
  end

  def send(email, document_id, callback_url)
    response = call :send_document, %{
            <tns:apiKey>#{@api_key}</tns:apiKey>
            <tns:senderInfo xsi:nil="true"/>
            <tns:documentCreationInfo>
              <ins0:recipients>
                <ins8:recipientInfo>
                  <ins8:email>#{email}</ins8:email>
                  <ins8:role>SIGNER</ins8:role>
                  <ins8:fax xsi:nil="true"/>
                </ins8:recipientInfo>
              </ins0:recipients>
              <ins0:name>test agreement</ins0:name>
              <ins0:message>this is a test message</ins0:message>
              <ins0:fileInfos>
                <ins0:fileInfo>
                  <ins0:fileName>Centra Coproration Centra Local Listing Contract ver 2</ins0:fileName>
                  <ins0:libraryDocumentKey>#{document_id}</ins0:libraryDocumentKey>
                  <ins0:mimeType xsi:nil="true"/>
                  <ins0:file xsi:nil="true"/>
                  <ins0:url xsi:nil="true"/>
                  <ins0:formKey xsi:nil="true"/>
                  <ins0:libraryDocumentName xsi:nil="true"/>
                </ins0:fileInfo>
              </ins0:fileInfos>
              <ins0:signatureType>ESIGN</ins0:signatureType>
              <ins0:signatureFlow>SENDER_SIGNATURE_NOT_REQUIRED</ins0:signatureFlow>
              <ins0:securityOptions xsi:nil="true"/>
              <ins0:externalId xsi:nil="true"/>
              <ins0:reminderFrequency xsi:nil="true"/>
              <ins0:callbackInfo>
                <ins0:signedDocumentUrl>#{callback_url}</ins0:signedDocumentUrl>
              </ins0:callbackInfo>
              <ins0:daysUntilSigningDeadline xsi:nil="true"/>
              <ins0:locale xsi:nil="true"/>
              <ins0:mergeFieldInfo xsi:nil="true"/>
            </tns:documentCreationInfo>
    }

    response.body[:send_document_response][:document_keys][:document_key][:document_key]
  end

  def get_form_data(document_key)
    response = call :get_form_data, {
        :apiKey => @api_key,
        :documentKey => document_key
    }

    csv_data = CSV.parse response.body[:get_form_data_response][:get_form_data_result][:form_data_csv]

    csv_hash = Hash.new
    field_count = csv_data[0].length-1

    (0..field_count).each do |i|
      csv_hash[csv_data[0][i]] = csv_data[1][i]
    end

    csv_hash
  end

  def get_documents
    response = call :get_my_documents, {:apiKey => @api_key}
    response.body[:get_my_documents_response][:get_my_documents_result][:document_list_for_user][:document_list_item]
  end

  def get_library_documents
    call :get_my_library_documents, {:apiKey => @api_key}
  end

  def cancel_document(document_key)
    call :cancel_document, {
        :apiKey => @api_key,
        :documentKey => document_key,
        :comment => "Testing document",
        :notifySigner => false
    }
  end

  private

  def call(resource, params)
    @client.call resource, :message => params
  end

end