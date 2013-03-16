require 'rack'

require File.expand_path("../crm-noting-api.rb", __FILE__)
require File.expand_path("../crm-noting-api2.rb", __FILE__)


use CrmNotingApi
run CrmNotingApi2
