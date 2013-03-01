require_relative "../../core/tests-base.rb"
require_relative "../../core/auth.rb"

require 'watir-webdriver'

class EchoSignTestsBase < TestsBase
  def setup
    @driver = Watir::Browser.new :phantomjs
    @email_client = EmailClient.new

    `screen -L -dmS echosign cd #{File.dirname(__FILE__)}/../../../echosign/ %% rakeup -p 9393`

    load_database
    clean_databases

    @auth = Auth.new @driver
    @auth.login
  end

  def teardown

  end


end