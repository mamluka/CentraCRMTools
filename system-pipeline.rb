require 'rubygems'
require 'active_record'
require 'active_support/all'

ActiveRecord::Base.establish_connection(
    :adapter  => 'mysql2',
    :database => 'jdeering_centracrm',
    :username => 'jdeering_david',
    :password => '0953acb',
    :host     => 'centracorporation.com')

class Lead < ActiveRecord::Base

end

week_old_leads = Lead.where('date_entered < ? and status= ?', 7.day.ago,'FU')

week_old_leads.each do |lead|
  lead.status = 'SP'
  lead.assigned_user_id =  '92b0bdb7-bb6c-449f-fa73-510054673707'
  lead.save
end

puts "we have modifued: " + week_old_leads.length.to_s + " leads"

