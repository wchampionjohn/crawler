class CreatePixnetUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :pixnet_users do |t|
      t.string :name, comment: 'pixnet username'
      t.integer :article_count
      t.timestamps null: false
    end
  end
end
