require 'json'

class Auth
  @config = File.dirname(__FILE__) + 'config_crm.json'

  def initialize(driver)
    @driver = driver
  end

  def login(username = nil, password = nil)
    config = JSON.parse(file.read(@config))

    username ||= config['admin_username']
    password ||= config['admin_password']

    b.text_field(:name => 'user_name').set username
    b.text_field(:name => 'user_password').set password
    b.button(:name => 'Login').click
  end
end