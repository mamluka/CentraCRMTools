require 'sinatra/base'
require 'sinatra/cross_origin'
require_relative '../../core/databases'

class NotesForm < Sinatra::Base
  set :static, true
  register Sinatra::CrossOrigin
  set :protection, :except => :frame_options

  configure do
    enable :cross_origin
  end

  get '/log' do
    @base_url = JSON.parse(File.read(File.dirname(__FILE__) + "/config.json"))['soa_base_url']
    @id = params[:id]

    erb :submit_action
  end

  post '/log' do
    Note.add params[:id], params[:subject], params[:note]
    'OK'
  end
end