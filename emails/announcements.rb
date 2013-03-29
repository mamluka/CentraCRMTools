class AnnouncementsEmails < LeadEmails
  def invalid_url_updated(customerId)
    lead = Lead.find(customerId)
    @name = lead.name
    @id = customerId

    prepare_email({to: :mobile_web, subject: "Invalid url was updated for #{@name}"})
  end

end