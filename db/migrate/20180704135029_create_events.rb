class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.string :title, limit: 40, null: false
      t.text :description
      t.string :place, limit: 50
      t.datetime :start_date, null: false
      t.datetime :end_date, null: false
      t.references :artist, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
