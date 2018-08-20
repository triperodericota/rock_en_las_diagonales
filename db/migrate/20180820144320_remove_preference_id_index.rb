class RemovePreferenceIdIndex < ActiveRecord::Migration[5.2]
  def change
    change_table :orders do |t|
      t.remove_index :preference_id
    end
  end
end
