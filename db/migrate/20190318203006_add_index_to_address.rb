class AddIndexToAddress < ActiveRecord::Migration[5.2]
  def change
    add_index :addresses, :zip
  end
end
