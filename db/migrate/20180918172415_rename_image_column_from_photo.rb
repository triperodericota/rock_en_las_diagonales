class RenameImageColumnFromPhoto < ActiveRecord::Migration[5.2]
  def change
    rename_column :photos, :image, :photo
  end
end
