class NonBillableEmails < LeadEmails
  layout "promotion"

  def not_the_right_person(email)

    prepare_email({to: email, subject: 'Please forward'})
  end

  def invalid_url(email, customer_id)
    @customer_id = customer_id

    prepare_email({to: email, subject: 'Account update'})
  end
end