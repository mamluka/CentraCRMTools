class CustomerUser < ActiveRecord::Base
  establish_connection 'otrs'

  self.table_name = "customer_user"

  has_many :tickets, :primary_key => 'id', :foreign_key => 'customer_id'
end

class Ticket < ActiveRecord::Base
  establish_connection 'otrs'

  self.table_name = "ticket"
end