class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.references :product, foreign_key: true, null: false
      t.references :fan, foreign_key: true, null: false
      t.references :state, foreign_key: true, null: false
      t.decimal :total_price, precision: 10, scale: 2, null: false, default: 0
      t.integer :units, null: false

      t.timestamps
    end
  end
end
