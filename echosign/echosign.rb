require 'grape'

class EchoSignApi < Grape::API
  format :json

  resource :echosign do
    desc "Return a public timeline."
    get :send do
      {:msg => 'hello'}
    end
  end

end