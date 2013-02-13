require 'mysql2'

client = Mysql2::Client.new(:database => 'jdeering_centracrm',
                            :username => 'jdeering_david',
                            :password => '0953acb',
                            :host => 'centracorporation.com')

puts client.query('select * from leads')