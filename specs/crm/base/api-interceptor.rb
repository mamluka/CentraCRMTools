require 'sinatra'
require 'json'

get_text '/api/email/*' do
  File.open('/tmp/api-call.json', 'w') { |file| file.write(params.to_json) }
  'OK'
end