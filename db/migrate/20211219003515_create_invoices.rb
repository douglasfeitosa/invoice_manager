class CreateInvoices < ActiveRecord::Migration[6.0]
  def change
    create_table :invoices do |t|
      t.references :user, null: false
      t.string :number, null: false
      t.datetime :date, null: false
      t.text :company, null: false
      t.text :billing_for, null: false
      t.decimal :total, precision: 14, scale: 2, null: false
      t.text :emails

      t.timestamps
    end

    add_foreign_key :invoices, :users
  end
end
