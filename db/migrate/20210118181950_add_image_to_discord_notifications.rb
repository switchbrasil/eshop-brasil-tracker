class AddImageToDiscordNotifications < ActiveRecord::Migration[6.1]
  def change
    add_column :discord_notifications, :image, :string
  end
end
