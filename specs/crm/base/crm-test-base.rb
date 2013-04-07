require 'json'
require 'time'

require 'watir-webdriver'
require 'headless'

require_relative "../../core/tests-base.rb"
require_relative "../../core/auth.rb"
require_relative "../../core/crm-lead.rb"

class CrmTestBase < TestsBase

  def setup
    super

    base_url = JSON.parse(File.read(File.dirname(__FILE__) + '/../../core/crm-config.json'))['base_url']

    @headless = Headless.new
    @headless.start

    @driver = Watir::Browser.start base_url

    @auth = Auth.new @driver
    @auth.login

    clean_databases
  end

  def teardown
    super
    capture_failed_snapshot @driver

    @auth.logout
    @driver.close
    @headless.destroy
  end
end