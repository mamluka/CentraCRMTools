require 'securerandom'
require 'time'

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
    custom_data = self.custom_data ||= CustomData.new
    if block_given?
      yield custom_data
    end

    self.custom_data = custom_data

    self.save
  end

  def name
    self.first_name
  end

  def email
    emails.first.email_address
  end
end

class CustomData < ActiveRecord::Base
  self.table_name = 'leads_cstm'
  self.primary_key = 'id_c'

  has_one :lead, :primary_key => 'id_c', :foreign_key => 'id', :autosave => true

  def do_not_email
    do_not_email_c
  end
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

class Note < ActiveRecord::Base
  def self.add(id, message, description)

    note = Note.new

    system_pipe_line_user = '92b0bdb7-bb6c-449f-fa73-510054673707'

    note.assigned_user_id = system_pipe_line_user

    note.parent_type = 'Leads'
    note.parent_id = id

    note.date_entered = Time.now
    note.date_modified = Time.now
    note.date_modified = Time.now
    note.created_by = system_pipe_line_user

    note.name = message
    note.description = description

    note.save
  end
end
