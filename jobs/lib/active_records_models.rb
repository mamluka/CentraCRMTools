class Lead < ActiveRecord::Base
  self.primary_key = 'id'
  has_one :custom_data, :primary_key => 'id', :foreign_key => 'id_c', :autosave => true
  has_one :email_relation, :primary_key => 'id', :foreign_key => 'bean_id'

  has_many :emails, :through => :email_relation

  def do_not_email
    custom_data.do_not_email_c
  end

  def add_email(email)
    email = Email.new
    email.email_address = "test@test.com"
    emails << email
  end

  def add_custom_data
    custom_data = CustomData.new
    yield custom_data
  end

  def name
    first_name
  end
end

class CustomData < ActiveRecord::Base
  self.table_name = 'leads_cstm'
  self.primary_key = 'id_c'
end


class Email < ActiveRecord::Base
  self.table_name = 'email_addresses'
  self.primary_key = 'id'
end

class EmailRelation < ActiveRecord::Base
  self.table_name = 'email_addr_bean_rel'
  self.primary_key = 'id'

  belongs_to :lead, :primary_key => 'id', :foreign_key => 'bean_id'
  belongs_to :email, :primary_key => 'id', :foreign_key => 'email_address_id'
end