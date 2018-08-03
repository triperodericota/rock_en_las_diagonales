class AddMaxPhotosAmountToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :max_photos_amount, :integer, default: 10
  end
end
