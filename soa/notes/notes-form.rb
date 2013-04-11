require 'sinatra/base'
require 'sinatra/cross_origin'

class NotesForm < Sinatra::Base
  set :static, true
  register Sinatra::CrossOrigin

  configure do
    enable :cross_origin
  end

  get '/log' do
    @base_url = JSON.parse(File.read(File.dirname(__FILE__) + "/config.json"))['crm_base_url']
    erb :submit_action
  end
end