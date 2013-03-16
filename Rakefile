require 'rake/testtask'
require 'io/console'
require 'json'

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
  puts "Enter sugarcrm database hosts #{reload_config(:database, 'host')}"
  database['host'] = STDIN.gets.strip

  puts "Enter sugarcrm database username"
  database['username'] = STDIN.gets.strip

  puts "Enter sugarcrm database password"
  database['password'] = STDIN.gets.strip

  puts "Enter sugarcrm database name"
  database['database'] = STDIN.gets.strip

  #echosign

  echosign = Hash.new

  puts "Enter echosign API key"
  echosign['apiKey'] = STDIN.gets.strip

  puts "Enter echosign username"
  echosign['username'] = STDIN.gets.strip

  puts "Enter echosign password"
  echosign['password'] = STDIN.gets.strip

  puts "Enter echosign callback url"
  echosign['callbackUrl'] = STDIN.gets.strip

  #email

  email = Hash.new

  puts "Enter service email login"
  email['username'] = STDIN.gets.strip

  puts "Enter service email password"
  email['password'] = STDIN.gets.strip

  puts "Enter service email host"
  email['host'] = STDIN.gets.strip

  #crm

  crm = Hash.new

  puts "Enter Centra apps base API url"
  crm['centraAppsApiBaseUrl'] = STDIN.gets.strip

  puts "Enter local listing dedicated email address"
  crm['localListingEmail'] = STDIN.gets.strip

  File.open('core/config.json', 'w') { |file| file.write(JSON.pretty_generate(email.merge(crm))) }
  File.open('core/database.json', 'w') { |file| file.write(JSON.pretty_generate(database)) }

  File.open('api/echosign/echosign.json', 'w') { |file| file.write(JSON.pretty_generate(echosign)) }

  File.open('config-history.json', 'w') do |file|
    file.write(JSON.pretty_generate({
                                        :crm => crm,
                                        :echosign => echosign,
                                        :database => database,
                                        :email => email
                                    }))
  end

end

def reload_config(hash_name, key)
  if File.exists?('config-history.json')
    return JSON.parse(File.read('config-history.json'))[hash_name.to_s][key]
  end

  "Not set yet!"
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