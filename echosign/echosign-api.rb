require 'grape'

class EchoSignApi < Grape::API
  format :json

  resource :echosign do
    desc "Return a public timeline."
    get :send do
      "OK"
    end

    put ':notify/:id' do
      params[:id]
    end
  end

end