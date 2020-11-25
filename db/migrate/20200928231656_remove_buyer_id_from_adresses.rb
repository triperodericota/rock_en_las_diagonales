class RemoveBuyerIdFromAdresses < ActiveRecord::Migration[5.2]
  def change
    remove_reference :buyers, :address, index: true
  end
end
