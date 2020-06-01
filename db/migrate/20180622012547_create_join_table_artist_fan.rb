class CreateJoinTableArtistFan < ActiveRecord::Migration[5.2]
  def change
    create_join_table :artists, :fans do |t|
      t.index [:artist_id, :fan_id]
    end
  end
end
