require 'sinatra'
require 'json'

get '/api/email/mobile-site-preview' do
  File.open('api-call.json', 'w') { |file| file.write(params.to_json) }
  'OK'
end

get '/api/email/google-local-listing-client-information-request' do
  File.open('api-call.json', 'w') { |file| file.write(params.to_json) }
  'OK'
end

get '/api/email/mobile-site-client-information-request' do
  File.open('api-call.json', 'w') { |file| file.write(params.to_json) }
  'OK'
end

get '/email/invalid-url' do
  File.open('api-call.json', 'w') { |file| file.write(params.to_json) }
  'OK'
end

get '/email/not-the-right-person' do
  File.open('api-call.json', 'w') { |file| file.write(params.to_json) }
  'OK'
end