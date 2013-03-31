require 'sinatra/base'
require_relative '../../core/databases'
require_relative '../../emails/announcements'

class Forms < Sinatra::Base
  set :static, true

  get '/invalid-url' do
    @id = params[:c]

    erb :invalid_url
  end

  post '/invalid-url' do

    crm = Databases.new
    crm.connect

    lead = Lead.find(params[:id])
    lead.website = params[:url]
    lead.save

    AnnouncementsEmails.invalid_url_updated(lead.id).deliver

    erb :invalid_url_done
  end

  get '/mobile-web-details' do
    @id = params[:c]

    erb :mobile_web_details
  end

  post '/mobile-web-details' do
    @id = params[:id]

    crm = Databases.new
    crm.connect

    lead = Lead.find(params[:id])
    lead.custom_data.host_dash_url_c = params[:hostingCompany]
    lead.custom_data.host_login_c = params[:hostingUsername]
    lead.custom_data.host_password_c = params[:hostingPassword]
    lead.custom_data.domain_host_name_c= params[:domainCompany]
    lead.custom_data.domain_host_username_c = params[:domainUsername]
    lead.custom_data.domain_host_password_c= params[:domainPassword]

    lead.save

    erb :mobile_web_details_done
  end
end
