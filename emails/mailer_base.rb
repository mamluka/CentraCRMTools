require 'action_mailer'
require 'json'

module Emails
  module Config
    def Config.get_config(config_file_name)
      JSON.parse(File.read(File.dirname(__FILE__) + "/" + config_file_name + '.json'))
    end

    def get_config(config_file_name)
      Config.get_config config_file_name
    end
  end
end

config = Emails::Config.get_config 'config'

ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
    :address => config['host'],
    :port => 25,
    :domain => config['domain'],
    :authentication => :plain,
    :user_name => config['username'],
    :password => config['password'],
    :enable_starttls_auto => true
}
ActionMailer::Base.view_paths= File.dirname(__FILE__)

class LeadEmails < ActionMailer::Base
  def prepare_email(options)

    config = get_config 'config'

    emailing_options = {:to => options[:to],
                        :from => options.has_key?(:from) ? options[:from] : config['service_email'],
                        :subject => options[:subject]}

    mail(emailing_options) do |format|
      format.text
      format.html
    end
  end
end


require_relative 'google_local_listing'
