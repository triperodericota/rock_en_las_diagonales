class RenameTotalPriceColumnFromOrders < ActiveRecord::Migration[5.2]
  def change
    rename_column :orders, :total_cost, :total_price
  end
end
