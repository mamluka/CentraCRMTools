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

class String
  def underscore
    self.gsub(/::/, '/').
        gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').
        gsub(/([a-z\d])([A-Z])/, '\1_\2').
        tr("-", "_").
        downcase
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

    if options.has_key?(:from)
      from = config[options[:from].to_s+'_email']
    else
      from = config['service_email']
    end

    if options[:to].is_a?(Symbol)
      to =config[options[:to].to_s + '_email']
    else
      to = options[:to]
    end

    @unsubscribe_link = config['unsubscribe_base'] + "?email=" + to
    @crm_base_url = config['crm_base_url']

    emailing_options = {:to => to,
                        :from => from,
                        :subject => options[:subject],
                        :reply_to => from}

    unless File.exist?(File.dirname(__FILE__) + "/#{self.class.name.underscore}/#{caller[0][/`.*'/][1..-2]}.html.erb")
      mail(emailing_options) do |format|
        format.text
      end
    else
      mail(emailing_options) do |format|
        format.text
        format.html
      end
    end
  end
end


require_relative 'google_local_listing'
require_relative 'mobile_web'
require_relative 'non_billable'
require_relative 'system_pipeline'
require_relative 'status'
require_relative 'announcements'
