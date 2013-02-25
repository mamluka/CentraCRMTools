require 'grape'
require_relative 'echosign'

class EchoSignApi < Grape::API
  format :json

  resource :echosign do
    desc "Return a public timeline."
    get :send do
      echosign = EchoSign.new
      begin
        echosign.send params[:email], "RWKW8L232Y3Z7F"
        "OK"
      rescue
        "ERROR"
      end
    end

    put 'notify/:id' do
      document_id = params[:id]
    end
  end

end