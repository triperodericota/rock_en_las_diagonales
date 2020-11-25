class AddDeliveryToOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :delivery, :boolean, null: false, default: false
  end
end
