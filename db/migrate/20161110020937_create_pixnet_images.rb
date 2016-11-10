class CreatePixnetImages < ActiveRecord::Migration[5.0]
  def change
    create_table :pixnet_images do |t|
      t.integer :article_id
      t.string :img
      t.string :url
      t.string :digest, limit: 64
      t.timestamps null: false
    end

    add_index :pixnet_images ,:article_id
    add_index :pixnet_images ,:digest
  end
end
