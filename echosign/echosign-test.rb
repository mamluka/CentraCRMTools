require 'savon'
require 'json'
require 'virgola'

require_relative "echosign"
require_relative "local-listing-form"

ll =  LocalListing.new

ll.update_crm('assdfs')

#class TestForm
#
#end
#
#echosign = EchoSign.new
#echosign.get_library_documents
#begin
#  puts echosign.send "david.mazvovsky@gmail.com", "SXEJ3DY771A3U53"
#rescue
#  puts "error"
#end
