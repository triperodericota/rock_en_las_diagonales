class RemoveStateIdFromOrders < ActiveRecord::Migration[6.0]
  def change
    remove_reference :orders, :state, index: true
  end
end
