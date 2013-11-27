class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :name
      t.string :genre
      t.decimal :price
      t.string :rating
      t.text :developer
      t.integer :stock_quantity
      t.references :platform

      t.timestamps
    end
  end
end
