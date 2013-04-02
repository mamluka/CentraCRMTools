require 'sinatra/base'
require_relative '../../core/databases'

class Support < Sinatra::Base
  set :static, true

  get 'submit' do
    erb :submit
  end



end