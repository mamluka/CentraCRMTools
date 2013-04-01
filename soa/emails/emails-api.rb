require 'grape'
require 'json'

require_relative '../../emails/mailer_base'
require_relative '../../core/databases'

class EmailsApi < Grape::API
  format :json

  get ':email_domain/:email_name' do
    method_name = params[:email_name].gsub(/-/, '_')
    class_name = params[:email_domain].split('-').map { |word| word.capitalize }.join('')

    begin
      email = Kernel.const_get(class_name + 'Emails').send(method_name.to_sym, params[:email], params)
    rescue ArgumentError
      email = Kernel.const_get(class_name + 'Emails').send(method_name.to_sym, params[:email])
    end

    email.deliver
    "OK"
  end

  get 'unsubscribe' do

    email = Email.where(:email_address => params[:email]).first

    if email.nil?
      return "You were already removed from our mailing list"
    end


    email.email_relation.lead.custom_data.do_not_email_c = true
    email.save

    "#{params[:email]} was successfully removed from the mailing list of Centra"
  end


end
