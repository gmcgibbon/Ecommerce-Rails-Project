class CreateCartItems < ActiveRecord::Migration
  def change
    create_table :cart_items do |t|
      t.integer :quantity
      t.decimal :price
      t.references :game
      t.references :order

      t.timestamps
    end
  end
end
