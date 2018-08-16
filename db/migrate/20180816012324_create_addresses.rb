class CreateAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :addresses do |t|
      t.string :state, limit: 40, null: false
      t.string :city, limit: 40, null: false
      t.string :street_name, limit: 25, null: false
      t.string :street_number, limit: 25, null: false
      t.string :zip, limit: 5, null: false
      t.string :apartament, limit: 5
      t.references :buyer, foreign_key: true

      t.timestamps
    end
  end
end
