require_relative 'base/jobs-base'

class Tests < JobsTestBase

  def test_sync_leads_with_ticketing_system_database

    lead = lead_with do |lead|
      lead.first_name = 'david'
      lead.last_name = 'mz'
    end

    lead.add_custom_data

    load_job 'sync-crm-leads-with-ticket-system'

    ticket_system_customer = CustomerUser.where(:login => lead.email).first

    assert_equal ticket_system_customer.login, 'crmtesting@centracorporation.com'
    assert_equal ticket_system_customer.email, 'crmtesting@centracorporation.com'
    assert_equal ticket_system_customer.customer_id, 'crmtesting@centracorporation.com'
    assert_equal ticket_system_customer.first_name, 'david'
    assert_equal ticket_system_customer.last_name, 'mz'
    assert_equal ticket_system_customer.create_by, 2
    assert_equal ticket_system_customer.change_by, 2
  end

  def test_synced_lead_should_be_marked

    lead = lead_with do |lead|
      lead.first_name = 'david'
      lead.last_name = 'mz'
    end

    lead.add_custom_data

    load_job 'sync-crm-leads-with-ticket-system'

    lead.reload

    assert lead.custom_data.has_otrs_user_c == true

  end

  def test_if_lead_is_synced_do_not_create_ticket_system_customer

    lead = lead_with do |lead|
      lead.first_name = 'david'
      lead.last_name = 'mz'
    end

    lead.add_custom_data do |data|
      data.has_otrs_user_c = true
    end

    load_job 'sync-crm-leads-with-ticket-system'

    ticket_system_customers_count = CustomerUser.count

    assert_equal ticket_system_customers_count, 0

  end
end