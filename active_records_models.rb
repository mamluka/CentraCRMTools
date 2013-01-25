class Lead < ActiveRecord::Base
  self.primary_key = 'id'
  has_one :leads_custom_data, :primary_key => 'id', :foreign_key => 'id_c'

  has_many :email_addresss, :through => :email_address_relations
end

class LeadsCustomData < ActiveRecord::Base
  self.table_name = 'leads_cstm'
  self.primary_key = 'id_c'
end


class EmailAddress < ActiveRecord::Base
  self.table_name = 'email_addresses'
  self.primary_key = 'id'
end

class EmailAddressRelation < ActiveRecord::Base
  self.table_name = 'email_addr_bean_rel'
  self.primary_key = 'id'

  belongs_to :lead, :primary_key => 'id', :foreign_key => 'bean_id'
  belongs_to :email_address, :primary_key => 'id', :foreign_key => 'email_address_id'
end