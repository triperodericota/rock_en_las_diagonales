class DropOrderStatesTable < ActiveRecord::Migration[6.0]
  def change
    drop_table :order_states
  end
end
