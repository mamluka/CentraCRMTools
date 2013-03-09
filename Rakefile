require 'rake/testtask'

Rake::TestTask.new("test:crm") do |t|
  t.pattern = "specs/crm/spec-*.rb"
end

Rake::TestTask.new("test:jobs") do |t|
  t.pattern = "specs/jobs/spec-*.rb"
end

Rake::TestTask.new("test:echosign") do |t|
  t.pattern = "specs/echosign/spec-*.rb"
end

namespace :crm do

  desc "Start services that support crm testing"
  task :testing do
    puts "Stating echosign..."
    `thin -d -p 9050 -R echosign/config.ru start`
  end
end