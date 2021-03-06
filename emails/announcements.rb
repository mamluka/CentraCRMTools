class AnnouncementsEmails < LeadEmails
  def invalid_url_updated(customerId)
    lead = Lead.find(customerId)
    @name = lead.name
    @id = customerId

    prepare_email({to: :mobile_web, subject: "Invalid url was updated for #{@name}"})
  end

  def remind_to_call_client_after_a_week_if_no_hosting_details(customerId)

    lead = Lead.find(customerId)
    @id = customerId
    @phone = lead.phone

    prepare_email({to: :mobile_web, subject: "#{lead.name} still did not fill in his provider details for mobile web"})
  end

  def remind_to_generate_a_report(customerId)
    lead = Lead.find(customerId)
    @name = lead.name

    prepare_email({to: :local_listing, subject: "A progress report should be generated for #{lead.name} as 3 weeks passed"})
  end

  def local_listing_contract_signed(customerId)
    lead = Lead.find(customerId)
    @name = lead.name

    prepare_email({to: :local_listing, subject: "#{lead.name} just signed a local listing contract"})
  end

  def mobile_web_contract_signed(customerId)
    lead = Lead.find(customerId)
    @name = lead.name

    prepare_email({to: :local_listing, subject: "#{lead.name} just signed a mobile web contract"})
  end

end