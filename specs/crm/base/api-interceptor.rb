require 'sinatra'
require 'json'

get '/api/email/mobile-site-preview' do
  File.open('api-call.json', 'w') { |file| file.write(params.to_json) }
  'OK'
end