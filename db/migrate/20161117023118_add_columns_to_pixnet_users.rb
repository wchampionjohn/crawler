class AddColumnsToPixnetUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :pixnet_users, :account, :string
    add_column :pixnet_users, :description, :text
    add_column :pixnet_users, :keyword, :string
    add_column :pixnet_users, :site_category, :string
    add_column :pixnet_users, :hits, :string
    add_column :pixnet_users, :avatar, :string
  end
end
