require 'json'
require 'time'

require_relative "../../core/tests-base.rb"
require_relative "../../core/auth.rb"
require_relative "../../core/crm-lead.rb"

class CrmTestBase < TestsBase

  def setup
    super
    @driver = Watir::Browser.new :phantomjs
    @auth = Auth.new @driver
    @auth.login

    load_database
    clean_databases
  end

  def teardown
    super
    @auth.logout

    test_name = Kernel.caller.flatten.select { |x| x.include?('test_') }.first

    puts test_name, Kernel.caller

    @driver.screenshot.save "#{test_name}.png"
  end
end