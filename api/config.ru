require 'rack'

require File.expand_path("../crm2excel/crm2excel.rb", __FILE__)
require File.expand_path("../crmnoting/crm-noting-api.rb", __FILE__)
require File.expand_path("../echosign/echosign-api.rb", __FILE__)

map "/api/crm2excel" do
  run Crm2ExcelApi
end

map "/api/crm" do
  run CrmNotingApi
end

map "/api/echosign" do
  run EchoSignApi
end