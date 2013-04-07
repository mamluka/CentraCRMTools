require 'json'
require 'securerandom'
class Auth


  def initialize(driver)
    @driver = driver

    config = File.dirname(__FILE__) + '/crm-config.json'
    @config = JSON.parse(File.read(config))
  end


  def login(username = nil, password = nil)

    username ||= @config['admin_username']
    password ||= @config['admin_password']

    @driver.goto @config['base_url']

    @driver.text_field(:name => 'user_name').set username
    @driver.text_field(:name => 'user_password').set password

    begin
      @driver.button(:name => 'Login').click
    rescue
      @driver.screenshot.save SecureRandom.uuid + "_login problem.png"
      @driver.button(:name => 'Login').click
    end

  end

  def logout
    @driver.goto @config['base_url'] + '/index.php?module=Users&action=Logout'
  end
end