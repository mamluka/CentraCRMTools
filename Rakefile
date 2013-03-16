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

task :config do
  #database

  database = Hash.new
  puts "Enter sugarcrm database hosts"
  database['host'] = STDIN.getch

  puts "Enter sugarcrm database username"
  database['username'] = STDIN.getch

  puts "Enter sugarcrm database password"
  database['password'] = STDIN.getch

  puts "Enter sugarcrm database name"
  database['database'] = STDIN.getch

  #echosign

  echosign = Hash.new

  puts "Enter echosign API key"
  echosign['apiKey'] = STDIN.getch

  puts "Enter echosign username"
  echosign['username'] = STDIN.getch

  puts "Enter echosign password"
  echosign['password'] = STDIN.getch

  puts "Enter echosign callback url"
  echosign['callbackUrl'] = STDIN.getch

  #email

  email = Hash.new

  puts "Enter service email login"
  email['username'] = STDIN.getch

  puts "Enter service email password"
  email['password'] = STDIN.getch

  puts "Enter service email host"
  email['host'] = STDIN.getch

  #crm

  crm = Hash.new

  puts "Enter Centra apps base API url"
  crm['centraAppsApiBaseUrl'] = STDIN.getch

  puts "Enter local listing dedicated email address"
  crm['localListingEmail'] = STDIN.getch

  File.open('core/config.json', 'w') { |file| file.write(JSON.generate(email.merge(crm))) }
  File.open('core/database.json', 'w') { |file| file.write(JSON.generate(database)) }

  File.open('api/echosign/echosign.json', 'w') { |file| file.write(JSON.generate(echosign)) }

  File.open('config-history.json', 'w') do |file|
    file.write(JSON.generate({
                                 :crm => crm,
                                 :echosign => echosign,
                                 :database => database,
                                 :email => email
                             }))
  end


end

namespace :crm do

  desc "Start services that support crm testing"
  task :testing do
    puts "Stating Apis..."
    puts `thin -d -a soa.centracorporation.com -p 9050 -P api.pid -R api/config.ru start`
  end

  task :stop_testing do
    puts "Stop Apis..."
    `thin -P api.pid stop`
  end
end