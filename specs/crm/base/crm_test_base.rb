require 'json'

class CrmTestBase < MiniTest::Unit::TestCase
  def assert_api_called(params)
    actual_api_call = JSON.parse(File.read('api-call.json'))

    params.each do |k, v|
      assert actual_api_call.has_key?(k.to_s) && actual_api_call[k.to_s] == v
    end
  end
end