require 'savon'

API_KEY = 'ZBVYTJ6J34656N'

client = Savon.client do
  wsdl "https://centra.echosign.com/services/EchoSignDocumentService15?wsdl"
  ssl_version :SSLv3
end
response = client.call :test_ping, :message => { :apiKey => API_KEY }

puts response
