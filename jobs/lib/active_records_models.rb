require 'securerandom'
class Lead < ActiveRecord::Base
  self.primary_key = 'id'
  has_one :custom_data, :primary_key => 'id', :foreign_key => 'id_c', :autosave => true
  has_one :email_relation, :primary_key => 'id', :foreign_key => 'bean_id'
  has_many :emails, :through => :email_relation

  before_create :set_id

  def set_id
    self.id = SecureRandom.uuid
  end

  def do_not_email
    custom_data.do_not_email_c
  end

  def add_email(email_address)
    email = Email.new
    email.email_address = email_address
    self.emails << email
  end

  def add_custom_data
    custom_data = CustomData.new
    if block_given?
      yield custom_data
    end

    self.custom_data = custom_data

    self.save
  end

  def name
    self.first_name
  end
end

class CustomData < ActiveRecord::Base
  self.table_name = 'leads_cstm'
  self.primary_key = 'id_c'
end


class Email < ActiveRecord::Base
  self.table_name = 'email_addresses'
  self.primary_key = 'id'

  before_create :set_id

  def set_id
    self.id = SecureRandom.uuid
  end

end

class EmailRelation < ActiveRecord::Base
  self.table_name = 'email_addr_bean_rel'
  self.primary_key = 'id'

  before_create :set_id

  def set_id
    self.id = SecureRandom.uuid
  end

  belongs_to :lead, :primary_key => 'id', :foreign_key => 'bean_id'
  belongs_to :email, :primary_key => 'id', :foreign_key => 'email_address_id'
end
