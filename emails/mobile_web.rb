class MobileWebEmails < LeadEmails
  layout 'promotion'

  def mobile_web_preview(email, preview_url)
    @preview_url = preview_url

    prepare_email({to: email, subject: 'Mobile Conversion is Almost Complete'})
  end

  def mobile_web_details_request(email, name, customer_id)
    @name = name
    @customer_id = customer_id

    prepare_email({to: email, subject: 'Mobile Site Going Live', from: 'centramobileweb@centracorporation.com'})
  end

  def mobile_web_live(email)
    prepare_email({to: email, subject: 'Your Mobile Site is Live', from: 'centramobileweb@centracorporation.com'})
  end


end