require 'json'

class Auth
  @@config = File.dirname(__FILE__) + '/config-crm.json'

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

    begin
      @driver.button(:name => 'Login').click
    rescue
      @driver.screenshot.save @__name__ + "_login problem.png"
      @driver.button(:name => 'Login').click
    end

  end

  def logout
    #link = @driver.link(:text => 'Log Out')
    #link.click if link.exists?
    @driver.goto 'http://crmtesting.centracorporation.com/index.php?module=Users&action=Logout'
  end
end