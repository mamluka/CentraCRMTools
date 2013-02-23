require 'savon'
require 'json'

require File.dirname(__FILE__) + "/echosign.rb"

#config = JSON.parse File.read(File.dirname(__FILE__) + "/echosign.json")
#
#API_KEY = config['apikey']
#
#client = Savon.client do
#  wsdl "https://centra.echosign.com/services/EchoSignDocumentService15?wsdl"
#  ssl_verify_mode :none
#end
#response = client.call :get_library_documents_for_user, :message => {:apiKey => API_KEY, :userCredentials => {email: config['email'], password: config['password']}}
#
#puts response.body
#
##response.body[:get_user_documents_response][:get_documents_for_user_result][:document_list_for_user][:document_list_item].each do |doc|
##  puts doc[:document_key]
##end

echosign = EchoSign.new
echosign.send "david.mazvovsky@gmail.com"
