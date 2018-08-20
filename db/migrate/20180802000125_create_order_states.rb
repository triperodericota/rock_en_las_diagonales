class CreateOrderStates < ActiveRecord::Migration[5.2]
  def change
    create_table :order_states do |t|
      t.datetime :date, null: false
      t.references :orders, foreign_key: true, null: false
      t.references :state, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
