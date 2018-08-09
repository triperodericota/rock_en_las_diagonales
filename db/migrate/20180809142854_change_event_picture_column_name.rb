class ChangeEventPictureColumnName < ActiveRecord::Migration[5.2]
  def change
    rename_column :events, :picture, :photo
  end
end
