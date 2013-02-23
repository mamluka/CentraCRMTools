require 'grape'

class EchoSignApi < Grape::API
  format :json

  resource :echosign do
    desc "Return a public timeline."
    get :send do
      "OK"
    end
  end

end