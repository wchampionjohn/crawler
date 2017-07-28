class CreateRutenUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :ruten_users do |t|
      t.string :account
      t.text :about
      t.integer :office_products_count
      t.integer :products_count
      t.integer :bad_point
      t.integer :soso_point
      t.integer :good_point
      t.text :memo

      t.timestamps
    end
  end
end
