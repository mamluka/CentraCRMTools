class MobileWebEmails < LeadEmails
  layout 'promotion'

  def mobile_web_preview(email, more)
    @preview_url = more[:previewUrl]

    prepare_email({to: email, subject: 'Mobile Conversion is Almost Complete', from: :mobile_web})
  end

  def mobile_web_details_request(email, more)
    @name = more[:name]
    @customer_id = more[:customerId]

    prepare_email({to: email, subject: 'Mobile Site Going Live', from: 'centramobileweb@centracorporation.com', from: :mobile_web})
  end

  def mobile_web_live(email)
    prepare_email({to: email, subject: 'Your Mobile Site is Live', from: 'centramobileweb@centracorporation.com', from: :mobile_web})
  end


end