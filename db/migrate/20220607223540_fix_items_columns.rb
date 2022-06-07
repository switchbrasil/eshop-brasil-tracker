class FixItemsColumns < ActiveRecord::Migration[6.1]
  def change
    remove_column :items, :screenshot_url
    remove_column :items, :developers
    remove_column :items, :publishers
    remove_column :items, :extra
    add_column :items, :item_type, :string, limit: 120
    add_column :items, :developer, :string, limit: 1024
    add_column :items, :publisher, :string, limit: 1024
  end
end
