class CustomerUser < ActiveRecord::Base
  establish_connection 'otrs'

  self.table_name = "customer_user"
end