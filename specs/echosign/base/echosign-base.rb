require_relative "../../core/tests-base.rb"

require 'watir-webdriver'

class EchoSignTestsBase < TestsBase
  def setup
    @driver = Watir::Browser.new :phantomjs
    @email_client = EmailClient.new

    `screen -L -dmS echosign  rakeup -p 9393 #{File.dirname(__FILE__)}/../../../echosign/config.ru`

    load_database
    clean_databases

    @auth = Auth.new @driver
    @auth.login
  end

  def teardown

  end


end