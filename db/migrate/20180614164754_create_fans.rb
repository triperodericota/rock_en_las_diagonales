class CreateFans < ActiveRecord::Migration[5.2]
  def change
    create_table :fans do |t|
      t.string :first_name, null: false, limit: 25
      t.string :last_name, null: false, limit: 25

      t.timestamps null: false
    end
  end
end