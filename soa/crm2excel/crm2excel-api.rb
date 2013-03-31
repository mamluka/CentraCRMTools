require 'grape'
require 'json'
require 'axlsx'
require 'date'

require_relative "../../core/databases"

class Crm2ExcelApi < Grape::API

  content_type :xlsx, "application/vnd.ms-excel.12"

  get :get do

    crm = Databases.new
    crm.connect

    rows = ActiveRecord::Base.connection.select_all('SELECT * FROM leads left join leads_cstm on leads.id = leads_cstm.id_c')

    filename = 'crm-report-' + Date.today.to_s + ".xlsx"

    Axlsx::Package.new do |p|
      p.workbook.add_worksheet(:name => "CRM clients") do |sheet|
        sheet.add_row rows.first.keys
        rows.shift

        rows.each do |row|
          sheet.add_row row.values
        end
      end

      p.serialize(filename)
    end

    IO.read(filename)
  end
end
