require 'sinatra/base'

class Forms < Sinatra::Base

  get '/invalid-url' do
    erb :invalid_url
  end

end
