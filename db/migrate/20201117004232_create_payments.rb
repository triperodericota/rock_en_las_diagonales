class CreatePayments < ActiveRecord::Migration[6.0]
  def change
    create_table :payments do |t|
      t.string :status, null: false, limit: 50
      t.string :type, null: false, limit: 50
      t.integer :merchant_order_id, null: false
      t.integer :mercadopago_payment_id, null: false
      t.string :external_reference
    end
  end
end
