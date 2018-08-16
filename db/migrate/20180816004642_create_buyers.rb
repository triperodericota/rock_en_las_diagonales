class CreateBuyers < ActiveRecord::Migration[5.2]
  def change
    create_table :buyers do |t|
      t.string :name, limit: 30, null: false
      t.string :surname, limit: 30, null: false
      t.integer :dni, limit: 8, null: false
      t.string :phone_number, limit: 8
      t.string :phone_cod_area, limit: 5
      t.string :email, null: false

      t.timestamps
    end
    add_index :buyers, :dni
    add_index :buyers, :email
  end
end
