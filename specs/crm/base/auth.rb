require 'json'

class Auth
  @@config = File.dirname(__FILE__) + '/config_crm.json'

  def initialize(driver)
    @driver = driver
  end


  def login(username = nil, password = nil)
    config = JSON.parse(File.read(@@config))

    username ||= config['admin_username']
    password ||= config['admin_password']

    @driver.goto 'crmtesting.centracorporation.com'

    @driver.text_field(:name => 'user_name').set username
    @driver.text_field(:name => 'user_password').set password
    @driver.button(:name => 'Login').click
  end

  def logout
    @driver.link(:text => 'Log Out').click
  end
end
