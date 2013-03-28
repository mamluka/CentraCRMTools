class AnnouncementsEmails < LeadEmails
  def invalid_url_updated(email, customerId)
    lead = lead.find(customerId)

    prepare_email({to: :mobile_web, subject: "Invalid url was updated for #{lead.name}"})
  end

end