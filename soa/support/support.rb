require 'sinatra/base'
require 'sinatra/cross_origin'
require_relative '../../core/databases'
require 'savon'
require 'time'

class Support < Sinatra::Base
  set :static, true
  register Sinatra::CrossOrigin

  configure do
    enable :cross_origin
  end

  get '/submit-ticket' do
    erb :submit_ticket
  end

  get '/crm-dashboard' do
    customer_id = params[:id]

    lead = Lead.find(customer_id)

    @email = lead.email
    @ticket_count = Ticket.count(:conditions => "customer_user_id = '#{@email}' and (ticket_state_id = 1 or ticket_state_id = 4)")

    erb :crm_dashboard
  end

  post '/submit-ticket' do

    email = params[:customerEmail]
    already_a_customer = CustomerUser.exists?(:login => email)

    unless already_a_customer
      customer = create_customer({
                                     email: email,
                                     first_name: 'unknown',
                                     last_name: 'unknown',
                                     phone: 'unknown',
                                     owner_id: 3
                                 })

      customer.save
    end

    customer_user = email

    client = Savon.client do
      wsdl 'http://support.centracorporation.com/otrs-web/GenericTicketConnector.wsdl'
      endpoint 'http://support.centracorporation.com/otrs/nph-genericinterface.pl/Webservice/GenericTicketConnector'
      convert_request_keys_to :camelcase
    end

    response = client.call(:ticket_create, message: {
        user_login: 'system',
        password: '0953acb',
        ticket: {
            title: params[:subject],
            customer_user: customer_user,
            queue: 'Client Support',
            state: 'open',
            priorityID: '3'
        },
        article: {
            content_type: 'text/plain; charset=utf8',
            subject: params[:subject],
            body: params[:issue]
        }
    })

    'Your ticket was sent'
  end


  post '/add-lead' do

    email = params[:email]

    customer = create_customer({
                                   email: email,
                                   first_name: params[:firstName],
                                   last_name: params[:lastName],
                                   phone: params[:phone],
                                   owner_id: 3
                               })
    customer.save

  end

  get '/migrate-all' do

    start = Time.now

    leads_data = CustomData.where('has_otrs_user_c is null or has_otrs_user_c = 0')

    puts " #{leads_data.length} leads found"

    leads_data.each do |data|

      puts "lead id " + data.lead.id

      lead = Lead.find(data.lead.id)

      puts "email is: " + lead.email

      if lead.email.empty?
        next
      end
      customer = create_customer({
                                     email: lead.email,
                                     first_name: lead.first_name,
                                     last_name: !lead.last_name.nil? ? lead.last_name : 'Not specified',
                                     phone: lead.phone_work,
                                     owner_id: 3
                                 })

      begin
        customer.save
      rescue ActiveRecord::RecordNotUnique
        puts "duplicate prevented"
      end

      lead.custom_data.has_otrs_user_c = true
      lead.save
    end


    "#{leads_data.length} has been processed took #{Time.now-start} seconds"
  end

  def create_customer(customer_details)

    email = customer_details[:email]
    owner_id = customer_details[:owner_id]

    customer = CustomerUser.new
    customer.login = email
    customer.email = email
    customer.customer_id = email
    customer.pw = 'not a real password'
    customer.title = 'Customer'
    customer.first_name = customer_details[:first_name]
    customer.last_name = customer_details[:last_name]
    customer.phone = customer_details[:phone]
    customer.valid_id = 1
    customer.create_time = Time.now
    customer.create_by = owner_id
    customer.change_time = Time.now
    customer.change_by = owner_id

    customer
  end

end