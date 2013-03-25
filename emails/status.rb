class StatusEmails < LeadEmails
  layout 'promotion'

  def cancellation(email)
    prepare_email({to: email, subject: 'We Would Like Your Feedback'})
  end

  def dead(email)
    prepare_email({to: email, subject: 'Our Door Is Always Open'})
  end
end