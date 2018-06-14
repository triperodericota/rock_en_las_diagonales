class AddProfileToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :profile_id, :integer
    add_column :users, :profile_type, :string

    add_index :users, [:profile_id, :profile_type]
  end
end
