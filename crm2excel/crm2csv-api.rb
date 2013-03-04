require 'grape'
require 'json'
require 'axlsx'
require 'date'

require_relative "../core/crm-database"

class Crm2ExcelApi < Grape::API

  content_type :xlsx, "application/vnd.ms-excel.12"

  resource :crm2excel do
    get :get do

      crm = CrmDatabase.new
      crm.connect

      rows = ActiveRecord::Base.connection.select_all('SELECT * FROM leads left join leads_cstm on leads.id = leads_cstm.id_c')

      Axlsx::Package.new do |p|
        p.workbook.add_worksheet(:name => "CRM clients") do |sheet|
          sheet.add_row rows.first.keys
          rows.shift

          rows.each do |row|
            sheet.add_row row.values
          end
        end

        filename = 'crm-report-' + Date.today.to_s + ".xlsx"
        p.serialize(filename)

        IO.read(filename)
      end
    end
  end
end
