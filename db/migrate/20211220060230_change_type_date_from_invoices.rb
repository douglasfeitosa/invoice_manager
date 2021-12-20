class ChangeTypeDateFromInvoices < ActiveRecord::Migration[6.0]
  def change
    change_column :invoices, :date, :date
  end
end
