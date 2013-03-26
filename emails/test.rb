require_relative "mailer_base"

email = GoogleLocalListingEmails.google_local_listing_heads_up "david.mazvovsky@gmail.com", "sdfsdf"
puts email

#email.deliver