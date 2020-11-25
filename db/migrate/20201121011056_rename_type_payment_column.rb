class RenameTypePaymentColumn < ActiveRecord::Migration[6.0]
  def change
    rename_column :payments, :type, :payment_type
  end
end
