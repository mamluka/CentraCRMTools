require_relative "lib/jobs-base"

class ResendMobileWebCustomerDataRequestJob < JobsBase

  def execute
    leads = CustomData.where('host_login_c is null and mobileweb_check_c = 1 and mobileweb_sale_date_c < ?', 7.days.ago).select { |x| !x.do_not_email }.map { |x| x.lead }.select { |x| x.status =="client" && x.emails.any? }
    logger.info "Found #{leads.length.to_s} mobile web clients that did not enter their data for a whole week"

    leads.each do |lead|
      message = <<-EOS
Dear jordan #{lead.name} still did not fill in his details,

You need to call him to his #{lead.phone_work} and ask for the details
Here is a link to the crm http://crm.centracorporation.com/index.php?module=Leads&action=DetailView&record=#{lead.id}
      EOS

      mailer.local_listing_system_message "#{lead.name} still did not fill in his provider details for mobile web", message

      Note.add lead.id, "A reminder was send to call collect hosting provider details, because they are still missing after a week"

      sleep 5
    end

    logger.info "#{leads.length.to_s} mobile web clients got a request data reminder"
  end
end

job = ResendMobileWebCustomerDataRequestJob.new
job.execute