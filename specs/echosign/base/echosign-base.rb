require_relative "../../core/tests-base.rb"
require_relative "../../../echosign/echosign"

require 'watir-webdriver'

class EchoSignTestsBase < TestsBase
  def setup
    super
    @driver = Watir::Browser.new :phantomjs
    @email_client = EmailClient.new

    `screen -L -dmS echosign  rackup -p 9393 #{File.dirname(__FILE__)}/../../../echosign/config.ru`

    load_database
    clean_databases

    @auth = Auth.new @driver
    @auth.login
  end

  def teardown
    #super
    `pkill -f 9393`
    clean_echosign_documents
  end

  def clean_echosign_documents
    echosign = EchoSign.new
    documents = echosign.get_documents

    keys = documents.select { |doc| doc[:name] == "test agreement" }.map { |doc| doc[:document_key] }

    keys.each do |key|
      echosign.cancel_document key
    end

    keys.each do |key|
      echosign.remove_document key
    end

  end


end