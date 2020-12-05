class CreateDiscordNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :discord_notifications, id: :uuid do |t|
      t.references :notificable, polymorphic: true, null: false, type: :uuid, index: true
      t.string :title
      t.string :description
      t.string :url
      t.string :thumbnail
      t.jsonb :fields, default: []
      t.datetime :sent_at

      t.timestamps
    end

    add_index :discord_notifications, :sent_at, where: 'sent_at IS NULL'
    add_index :discord_notifications, :created_at, order: { created_at: :desc }
  end
end
