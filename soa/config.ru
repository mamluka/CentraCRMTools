gem 'rack', '1.4.5' #damn action mailer needs this
require 'rack'

require File.expand_path("../crm2excel/crm2excel-api.rb", __FILE__)
require File.expand_path("../notes/noting-api.rb", __FILE__)
require File.expand_path("../notes/notes-form.rb", __FILE__)
require File.expand_path("../echosign/echosign-api.rb", __FILE__)
require File.expand_path("../emails/emails-api.rb", __FILE__)
require File.expand_path("../forms/forms.rb", __FILE__)
require File.expand_path("../support/support.rb", __FILE__)

map '/api/crm2excel' do
  run Crm2ExcelApi
end

map '/api/crm' do
  run CrmNotingApi
end

map '/api/echosign' do
  run EchoSignApi
end

map '/api/emails' do
  run EmailsApi
end

map '/forms' do
  run Forms.new
end

map '/support' do
  run Support.new
end

map '/crm/notes' do
  run NotesForm.new
end
