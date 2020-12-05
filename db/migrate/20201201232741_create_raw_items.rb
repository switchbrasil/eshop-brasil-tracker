class CreateRawItems < ActiveRecord::Migration[6.1]
  def change
    create_table :raw_items, id: :uuid do |t|
      t.references :item, foreign_key: true, type: :uuid
      t.string :external_id, null: false, limit: 128
      t.jsonb :data, default: {}
      t.string :checksum, null: false, limit: 512
      t.boolean :imported, default: false

      t.timestamps
    end

    add_index :raw_items, :external_id, unique: true
    add_index :raw_items, :imported, where: 'imported = false'
  end
end
