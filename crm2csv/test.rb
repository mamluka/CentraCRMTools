require 'axlsx'
require_relative "../core/crm-database"

crm = CrmDatabase.new
crm.connect

var rows = ActiveRecord::Base.connection.select_all('SELECT * FROM leads left join leads_cstm on leads.id = leads_cstm.id_c')


Axlsx::Package.new do |p|
  p.workbook.add_worksheet(:name => "CRM clients") do |sheet|
    sheet.add_row rows.first.keys
    rows.shift

    rows.each do |row|
      sheet.add row.values
    end
  end
  p.serialize('simple.xlsx')
end
