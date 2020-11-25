class RemoveOrderIdFromAdresses < ActiveRecord::Migration[6.0]
  def change
    remove_reference :addresses, :order, index: true
    remove_reference :addresses, :orders, index: true
  end
end
