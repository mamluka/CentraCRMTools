require 'savon'
require 'json'

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

  def send(email)
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
                  <ins0:libraryDocumentKey>RWKW8L232Y3Z7F</ins0:libraryDocumentKey>
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
                <ins0:signedDocumentUrl></dto:signedDocumentUrl>
              </ins0:callbackInfo>
              <ins0:daysUntilSigningDeadline xsi:nil="true"/>
              <ins0:locale xsi:nil="true"/>
              <ins0:mergeFieldInfo xsi:nil="true"/>
            </tns:documentCreationInfo>
    }
  end

  private

  def call(resource, params)
    @client.call resource, :message => params
  end

end