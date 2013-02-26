require_relative "../core/crm-database"

class LocalListing

  def initialize(csv_hash)
    @csv_hash = csv_hash
  end

  def update_crm(document_id)

    db = CrmDatabase.new
    db.connect

    lead_id = CustomData.where(:echosign_doc_id => document_id).id

    lead = Lead.find(lead_id)

    puts lead.first_name

  end
end