require "bundler/setup"

require 'rack'
require "rack/stack"

require File.expand_path("../crm-noting-api.rb", __FILE__)
require File.expand_path("../crm-noting-api2.rb", __FILE__)

map "/1" do
  run CrmNotingApi
end

map "/2" do
  run CrmNotingApi2
end