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
  include Emails::Config

  def prepare_email(options)

    config = get_config 'config'

    @unsubscribe_link = config['unsubscribe_base'] + "?email=" + options[:to]

    if options.has_key?(:from)
      from = config['from_'+options[:from].to_s]
    else
      from = config['from_service']
    end

    emailing_options = {:to => options[:to],
                        :from => from,
                        :subject => options[:subject],
                        :reply_to => from}


    mail(emailing_options) do |format|
      format.text
      format.html
    end
  end
end


require_relative 'google_local_listing'
require_relative 'mobile_web'
require_relative 'non_billable'
require_relative 'system_pipeline'
require_relative 'status'
