class Lead < ActiveRecord::Base
  has_one :leads_custom_data, :primary_key => 'id', :foreign_key => 'id_c'
end

class LeadsCustomData < ActiveRecord::Base
  self.table_name = 'leads_cstm'
  self.primary_key = 'id_c'
end


class EmailAddress < ActiveRecord::Base
  self.table_name = 'email_addresses'
end

class EmailAddressRelation < ActiveRecord::Base
  self.table_name = 'email_addr_bean_rel'
end