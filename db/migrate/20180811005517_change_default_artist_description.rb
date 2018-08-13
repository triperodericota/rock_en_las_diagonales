class ChangeDefaultArtistDescription < ActiveRecord::Migration[5.2]
  def change
    change_column :artists, :description, :text, default: ''
  end
end
