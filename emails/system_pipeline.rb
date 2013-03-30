class SystemPipelineEmails < LeadEmails
  layout "promotion"

  def first_system_pipeline(email, preview_url)
    @preview_url = preview_url

    prepare_email({to: email, subject: 'Touching Base'})
  end

  def second_system_pipeline(email, preview_url)
    @preview_url = preview_url

    prepare_email({to: email, subject: 'Busy Is Good'})
  end


end