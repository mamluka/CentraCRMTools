gem 'rack', '1.4.5' #damn action mailer needs this
require 'rack'

require File.expand_path("../crm2excel/crm2excel-api.rb", __FILE__)
require File.expand_path("../notes/noting-api.rb", __FILE__)
require File.expand_path("../notes/notes-form.rb", __FILE__)
require File.expand_path("../echosign/echosign-api.rb", __FILE__)
require File.expand_path("../emails/emails-api.rb", __FILE__)
require File.expand_path("../forms/forms.rb", __FILE__)
require File.expand_path("../support/support.rb", __FILE__)

logger = Logger.new('log/app.log')


map '/api/crm2excel' do
  use Rack::CommonLogger, logger
  run Crm2ExcelApi
end

map '/api/crm' do
  use Rack::CommonLogger, logger
  run CrmNotingApi
end

map '/api/echosign' do
  use Rack::CommonLogger, logger
  run EchoSignApi
end

map '/api/emails' do
  use Rack::CommonLogger, logger
  run EmailsApi
end

map '/forms' do
  use Rack::CommonLogger, logger
  run Forms.new
end

map '/support' do
  use Rack::CommonLogger, logger
  run Support.new
end

map '/crm/notes' do
  use Rack::CommonLogger, logger
  run NotesForm.new
end
