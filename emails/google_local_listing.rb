class GoogleLocalListingEmails < LeadEmails

  layout 'promotion'

  def google_local_listing_live(email)

    prepare_email({to: email, subject: "Your Business is now Live in Google", from: :local_listing})

  end

  def google_local_listing_heads_up(email, more)

    @customer_id = more[:customerId]

    prepare_email({to: email, subject: "Google Verification", from: :local_listing})
  end

  def google_local_listing_pin_reminder(email, customer_id)

    @customer_id = customer_id

    prepare_email({to: email, subject: "Google Reminder", from: :local_listing})
  end
end