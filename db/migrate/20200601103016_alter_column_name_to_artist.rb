class AlterColumnNameToArtist < ActiveRecord::Migration[5.2]
  def change
    change_column :artists, :name, :string, :limit => 255
  end
end
