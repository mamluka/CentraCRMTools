require_relative "../../core/tests-base.rb"
require_relative "../../../echosign/echosign"

require 'watir-webdriver'

class EchoSignTestsBase < TestsBase
  def setup
    super
    @driver = Watir::Browser.new :phantomjs
    @email_client = EmailClient.new

    load_database
    clean_databases

    @auth = Auth.new @driver
    @auth.login
  end

  def teardown
    super
    clean_echosign_documents "Mobile Web Presence Discount"
    clean_echosign_documents "Mobile Web"
    clean_echosign_documents "Centra Gift"
  end

  def clean_echosign_documents(name)
    echosign = EchoSign.new
    documents = echosign.get_documents

    keys = documents.select { |doc| doc[:name] == name }.map { |doc| doc[:document_key] }

    keys.each do |key|
      echosign.cancel_document key
    end

    keys.each do |key|
      echosign.remove_document key
    end

  end


  def assert_price_point(price)
    # needs to be worked out
  end


end