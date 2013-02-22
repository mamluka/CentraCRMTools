require 'savon'
require 'json'

config = JSON.parse File.read(File.dirname(__FILE__) + "/echosign.json")

API_KEY = config['apikey']

client = Savon.client do
  wsdl "https://centra.echosign.com/services/EchoSignDocumentService15?wsdl"
  ssl_verify_mode :none
end
response = client.call :get_user_documents, :message => {:apiKey => API_KEY, :userCredentials => {email: config['email'], password: config['password']}}

#puts response.body[:get_user_documents_response][:get_documents_for_user_result][:document_list_for_user][:document_list_item]

#response.body[:get_user_documents_response][:get_documents_for_user_result][:document_list_for_user][:document_list_item].each do |doc|
#  puts doc[:document_key]
#end

key = response.body[:get_user_documents_response][:get_documents_for_user_result][:document_list_for_user][:document_list_item].last[:document_key]
puts key

form_data = client.call :get_form_data, :message => {:apiKey => API_KEY, :documentKey => 'RWKWE73J68757D'}

puts form_data.body
