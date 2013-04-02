require 'sinatra/base'
require_relative '../../core/databases'

class LeadGen < Sinatra::Base
  set :static, true

  get '/submit' do
    erb :submit
  end

end