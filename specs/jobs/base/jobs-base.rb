require 'minitest/autorun'
require 'active_record'
require 'active_support/all'
require 'securerandom'
require 'mail'

current_dir = File.dirname(__FILE__)

require current_dir + "/../../../jobs/lib/init.rb"
require current_dir + "/../../../jobs/lib/active_records_models.rb"
require current_dir + "/../../core/tests-base.rb"

$test_user_id = '8d71be80-cc24-cda3-e4d6-50d8a70d9d20'

class JobsTestBase < TestsBase

  @@current_dir = File.dirname(__FILE__)

  def setup
    super
    clean_databases

  end

  def load_job(job_file)
    load @@current_dir + '/../../../jobs/' + job_file +'.rb'
  end

  def lead_with
    lead = Lead.new
    lead.assigned_user_id =$test_user_id
    lead.first_name = SecureRandom.uuid
    lead.last_name = SecureRandom.uuid

    yield lead

    lead.save
    lead.add_email "crmtesting@centracorporation.com"

    lead.add_custom_data

    lead.save
    lead
  end

  def emails
    @emails
  end


end