class CreatePixnetArticles < ActiveRecord::Migration[5.0]
  def change
    create_table :pixnet_articles do |t|
      t.integer :user_id, null:false
      t.integer :origin_id, null:false, comment: 'pixnet origin article id'
      t.string :title
      t.text :content
      t.timestamps null: false
    end

    add_index :pixnet_articles ,:user_id
    add_index :pixnet_articles ,:origin_id
  end
end
