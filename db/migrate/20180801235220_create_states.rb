class CreateStates < ActiveRecord::Migration[5.2]
  def change
    create_table :states do |t|
      t.string :description, limit: 40, null: false
      t.string :type, null: false
      t.string :name, limit: 20, null: false, unique: true

      t.timestamps
    end
  end
end
