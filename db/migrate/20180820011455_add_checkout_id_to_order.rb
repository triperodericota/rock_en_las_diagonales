class AddCheckoutIdToOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :preference_id, :integer
  end
  add_index :orders, :preference_id, unique: true
end
