require 'sinatra/base'
require_relative '../../core/databases'
require 'savon'

class Support < Sinatra::Base
  set :static, true

  get '/submit-ticket' do
    erb :submit_ticket
  end

  post '/submit-ticket' do

    email = Email.where(email_address => params[:customerEmail]).first

    if email.nil?
      customer_user = "unknown_customer"
    else
      email.email_relation.lead.custom_data.do_not_email_c = true
    end

    client = Savon.client do
      wsdl "http://127.0.0.1/otrs-web/GenericTicketConnector.wsdl"
      endpoint "http://localhost/otrs/nph-genericinterface.pl/Webservice/GenericTicketConnector"
      convert_request_keys_to :camelcase
    end

    response = client.call(:ticket_create, message: {
        user_login: "system",
        password: "0953acb",
        ticket: {
            title: "yeah",
            customer_user: "moshe",
            queue: "Misc",
            state: "open",
            priorityID: "3"
        },
        article: {
            content_type: "text/plain; charset=utf8",
            subject: "yeah new sext stuff",
            body: "this is a cool body"
        }
    })

    response
  end

  get 'find-lead' do

  end

end