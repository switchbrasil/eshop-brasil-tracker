class ChangeItemColumns < ActiveRecord::Migration[6.1]
  def change
    change_column :items, :main_picture_url, :string, limit: 5000, null: true
    change_column :items, :banner_picture_url, :string, limit: 5000
    change_column :items, :release_date, :date, null: true
    change_column :items, :release_date_display, :string, null: true
  end
end
