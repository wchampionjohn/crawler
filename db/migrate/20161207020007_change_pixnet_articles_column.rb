class ChangePixnetArticlesColumn < ActiveRecord::Migration[5.0]
  def up
    change_column :pixnet_articles, :content, :longtext
  end

  def down
    change_column :pixnet_articles, :content, :text
  end
end
