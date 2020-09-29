class RemoveBuyerIdFromAdresses < ActiveRecord::Migration[5.2]
  def change
    remove_reference :addresses, :buyer, index: true
  end
end
