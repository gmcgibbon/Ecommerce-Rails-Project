class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.text :status
      t.decimal :pst
      t.decimal :gst
      t.decimal :hst
      t.references :customer

      t.timestamps
    end
  end
end
