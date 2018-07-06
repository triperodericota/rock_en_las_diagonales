class CreateAudiences < ActiveRecord::Migration[5.2]
  def change
    create_table :audiences do |t|
      t.references :event, foreign_key: true
      t.references :fan, foreign_key: true

      t.timestamps
    end
  end
end
