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
  database['host'] = read_config_value "Enter sugarcrm database hosts", "host", :database
  database['username'] = read_config_value "Enter sugarcrm database username", "username", :database
  database['password'] = read_config_value "Enter sugarcrm database password", "password", :database
  database['database'] = read_config_value "Enter sugarcrm database name", "database", :database

  #echosign

  echosign = Hash.new

  echosign['apiKey'] = read_config_value "Enter echosign API key", "apiKey", :echosign
  echosign['username'] = read_config_value "Enter echosign username", "username", :echosign
  echosign['password'] = read_config_value "Enter echosign password", "password", :echosign
  echosign['callbackUrl'] = read_config_value "Enter echosign callback url", "callbackUrl", :echosign

  #email

  email = Hash.new

  email['username'] = read_config_value "Enter service email login", "username", :email
  email['password'] = read_config_value "Enter service email password", "password", :email
  email['host'] =read_config_value "Enter service email host", "host", :email

  #crm

  crm = Hash.new

  crm['centraAppsApiBaseUrl'] =read_config_value "Enter Centra apps base API url", "centraAppsApiBaseUrl", :crm
  crm['localListingEmail'] = read_config_value "Enter local listing dedicated email address", "localListingEmail", :crm

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

def read_config_value(text, key, section)
  saved_value = reload_config_from_history(section, key)

  puts "#{text} [#{saved_value}]"
  tmp = STDIN.gets.strip
  using_value = !tmp.empty? ? tmp : saved_value
  puts "using => #{using_value}"

  using_value
end


def reload_config_from_history(hash_name, key)
  if File.exists?('config-history.json')
    return JSON.parse(File.read('config-history.json'))[hash_name.to_s][key]
  end

  "Not set yet!"
end

namespace :crm do

  desc "put the services up"

  task :start do
    puts "Stating APIs"
    puts `thin -d -a soa.centracorporation.com -p 8081 -P api.pid -R api/config.ru start`
  end


  desc "Start services that support crm testing"
  task :testing do
    puts "Stating Apis..."
    puts `thin -d -a soa.centracorporation.com -p 9050 -P api.pid -R api/config.ru start`
  end

  desc "Stop crm testing"
  task :stop_testing do
    puts "Stop Apis..."
    `thin -P api.pid stop`
  end
end