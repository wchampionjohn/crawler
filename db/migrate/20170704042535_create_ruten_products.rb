class CreateRutenProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :ruten_products do |t|
      t.string :title
      t.string :url
      t.string :main_img
      t.integer :price
      t.string :amount
      t.integer :sale_out_num
      t.string :pay_way
      t.string :transport_way
      t.string :situation
      t.string :location
      t.datetime :launched_date
      t.string :origin_id
      t.string :user_id

      t.timestamps
    end
  end
end
