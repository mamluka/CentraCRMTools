require 'minitest/autorun'
require 'watir-webdriver'

class TestMini < MiniTest::Unit::TestCase

  def setup
    @driver = Watir::Browser.new :phantomjs
  end

  def test_this_test
    auth = Auth.new(@driver)
    auth.login

    puts @driver.text
  end
end
	




