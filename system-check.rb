require 'active_record'
require 'active_support/all'

ActiveRecord::Base.establish_connection(
    :adapter  => 'mysql2',
    :database => 'jdeering_centracrm',
    :username => 'jdeering_david',
    :password => '0953acb',
    :host     => 'centracorporation.com')
