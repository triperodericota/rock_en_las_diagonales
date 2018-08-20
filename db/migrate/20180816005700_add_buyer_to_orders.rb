class AddBuyerToOrders < ActiveRecord::Migration[5.2]
  def change
    add_reference :orders, :buyer, index: true
    add_foreign_key :orders, :buyer
  end
end
