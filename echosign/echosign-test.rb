require 'savon'
require 'json'

require File.dirname(__FILE__) + "/echosign.rb"

echosign = EchoSign.new
echosign.send "david.mazvovsky@gmail.com"


