require_relative '../lib/jobs-base'
require_relative '../../emails/mailer_base'

class SyncTicketSystemJob < JobsBase

  def execute
    leads = CustomData.where(:has_otrs_user_c => false).map { |x| x.lead }.select { |x| x.emails.any? }

    logger.info "Found #{leads.length} leads that were not synced with ticketing system"

    leads.each do |lead|
      logger.info "Syncing #{lead.name}"

      customer = create_customer({email: lead.email,
                                  owner_id: 2,
                                  first_name: lead.first_name,
                                  last_name: (lead.last_name.nil? ? 'unknown' : lead.last_name),
                                  phone : lead.phone_work})

      begin
        customer.save
      rescue ActiveRecord::RecordNotUnique
        logger.info 'Prevented duplication'
      end

      lead.custom_data.has_otrs_user_c = true
      lead.save
    end

    logger.info "Synced #{leads.length} leads"

  end

  def create_customer(customer_details)

    email = customer_details[:email]
    owner_id = customer_details[:owner_id]

    customer = CustomerUser.new
    customer.login = email
    customer.email = email
    customer.customer_id = email
    customer.pw = 'not a real password'
    customer.title = 'Customer'
    customer.first_name = customer_details[:first_name]
    customer.last_name = customer_details[:last_name]
    customer.phone = customer_details[:phone]
    customer.valid_id = 1
    customer.create_time = Time.now
    customer.create_by = owner_id
    customer.change_time = Time.now
    customer.change_by = owner_id

    customer
  end

end

job = SyncTicketSystemJob.new
job.execute