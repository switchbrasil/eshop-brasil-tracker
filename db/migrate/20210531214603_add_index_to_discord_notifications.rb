class AddIndexToDiscordNotifications < ActiveRecord::Migration[6.1]
  def change
    remove_index :discord_notification, name: 'index_discord_notifications_on_created_at'
    remove_index :discord_notification, name: 'index_discord_notifications_on_sent_at'

    add_index :discord_notifications,
      %i[notificable_type sent_at title],
      where: 'sent_at IS NULL',
      name: :idx_type_sent_at_title
  end
end
