require_relative "../core/crm-database"

class LocalListing

  def initialize(csv_hash)
    @csv_hash = csv_hash
  end

  def update_crm(document_id)

    db = CrmDatabase.new
    db.connect

    lead = CustomData.where(:echosign_doc_id_c => document_id).first.lead

    puts lead.first_name

  end
end