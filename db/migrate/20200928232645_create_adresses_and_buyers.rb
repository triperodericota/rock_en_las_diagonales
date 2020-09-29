class CreateAdressesAndBuyers < ActiveRecord::Migration[5.2]
  def change
    create_table :adresses_and_buyers do |t|
      t.belongs_to :address, index: true
      t.belongs_to :buyer, index: true
    end
  end
end
