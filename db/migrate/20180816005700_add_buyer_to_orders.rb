class AddBuyerToOrders < ActiveRecord::Migration[5.2]
  def change
    add_reference :orders, :buyers, index: true
    add_foreign_key :orders, :buyers
  end
end
