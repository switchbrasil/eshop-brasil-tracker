class CreateItems < ActiveRecord::Migration[6.1]
  def change
    create_table :items, id: :uuid do |t|
      t.string :external_id, null: false, limit: 128
      t.string :title, null: false, limit: 256
      t.string :slug, null: false, limit: 512
      t.string :description, limit: 4096
      t.string :website_url, null: false
      t.string :nsuid, limit: 128
      t.string :main_picture_url, null: false, limit: 512
      t.string :banner_picture_url, limit: 512
      t.string :screenshot_url, limit: 512
      t.string :genres, array: true, default: []
      t.string :developers, array: true, default: []
      t.string :publishers, array: true, default: []
      t.string :franchises, array: true, default: []
      t.jsonb :extra, default: {}

      t.date :release_date, null: false
      t.string :release_date_display, null: false

      t.timestamps
    end

    add_index :items, :slug, unique: true
    add_index :items, :external_id, unique: true
  end
end
