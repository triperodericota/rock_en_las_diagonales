class CreateArtist < ActiveRecord::Migration[5.2]
  def change
    create_table :artists do |t|
      t.text :description
      t.string :name, limit: 30
    end

    add_index :artists, :name, unique: true
  end
end
