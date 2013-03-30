class NonBillableEmails < LeadEmails
  layout "promotion"

  def not_the_right_person(email)

    prepare_email({to: email, subject: 'Please forward'})
  end

  def invalid_url(email, more)
    @customer_id = more[:customerId]

    prepare_email({to: email, subject: 'Account update'})
  end
end