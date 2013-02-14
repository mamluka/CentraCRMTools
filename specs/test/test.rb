require 'minitest/autorun'
require 'watir-webdriver'

class TestMini < MiniTest::Unit::TestCase
	def test_this_test
		b = Watir::Browser.new :phantomjs
		b.goto "http://crmtesting.centracorporation.com"
		b.text_field(:name=>'user_name').set 'centradavid'
		b.text_field(:name=>'user_password').set '0953@AcB'
		b.button(:name=>'Login').click

		puts b.text
	end
end
	




