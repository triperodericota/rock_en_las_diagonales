class ChangePreferenceIdFromOrders < ActiveRecord::Migration[5.2]
  def change
    change_column :orders, :preference_id, :string
  end
  add_index :orders, :preference_id, unique: true
end
