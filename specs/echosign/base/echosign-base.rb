require_relative "../../core/tests-base"
require_relative "../../../api/echosign/echosign"

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

    capture_failed_snapshot @sriver

    @driver.close
  end

  def clean_echosign_documents(name)
    echosign = EchoSign.new
    documents = echosign.get_documents

    if documents == nil
      return
    end

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