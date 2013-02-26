require 'savon'
require 'json'
require 'virgola'

require_relative "echosign"
require_relative "local-listing-form"

#class TestForm
#
#end
#
echosign = EchoSign.new
#echosign.get_library_documents
#begin
#  puts echosign.send "david.mazvovsky@gmail.com", "SXEJ3DY771A3U53"
#rescue
#  puts "error"
#end

#puts echosign.get_form_data "SXFFXV4T4Z483R"

ll = LocalListing.new({})
ll.update_crm('aaa')