class GoogleLocalListingEmails < LeadEmails

  layout 'promotion'

  def google_local_listing_live(email)

    prepare_email({to: email, subject: "Your Business is now Live in Google"})

  end

  def google_local_listing_heads_up(email, customerId)

    @customer_id = customerId

    prepare_email({to: email, subject: "Google Verification"})
  end

  def google_local_listing_pin_reminder(email, customerId)

    @customer_id = customerId

    prepare_email({to: email, subject: "Google Reminder"})
  end
end