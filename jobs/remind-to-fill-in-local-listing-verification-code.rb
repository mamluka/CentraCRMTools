require_relative "lib/jobs-base"

class ReminderToFillInGoogleLocalListingCode < JobsBase

  def execute
    leads = CustomData.where('googlelocal_verified_date_c < ? and googlelocal_verified_c = 1', 7.days.ago).select { |x| !x.do_not_email }.map { |x| x.lead }.select { |x| x.status == "client" && x.emails.any? }
    logger.info "Found #{leads.length.to_s} google local listing clients that were verified a week ago"

    leads.each do |lead|
      email = lead.email
      logger.info "#{lead.name} will get a reminder to fill in google code to #{email}"

      res = mailer.google_local_listing_verification_reminder email, lead.id

      if res=="OK"
        sleep 5
      else
        logger.info "Api returned error response: " + res
      end
    end

    logger.info "#{leads.length.to_s} google local listing clients got a reminder"
  end
end

job = ReminderToFillInGoogleLocalListingCode.new
job.execute