class ChangeDefaultProductDescription < ActiveRecord::Migration[5.2]
  def change
    change_column :products, :description, :text, default: "No hay descripción de este producto"
  end
end
