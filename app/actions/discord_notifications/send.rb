module DiscordNotifications
  class Send < Actor
    PRICES_WEBHOOK_URL = 'https://discord.com/api/webhooks/784085888631308379/0wylP_yojNRPIbfA_zIhYlC5nChasntE_JhONyng11LbnrSvPMdDXh8hEBokPxIl4xfw'.freeze
    GAMES_WEBHOOK_URL = 'https://discord.com/api/webhooks/849036968833581099/8XxYMcN8No_vBlbqcQdFlWgOMgSehWJyRDVKoSL9zJmPG5rPKNfbmOJd-ZnxuAnKqinB'.freeze

    def call
      send_notifications_to(PRICES_WEBHOOK_URL, :from_prices)
      send_notifications_to(GAMES_WEBHOOK_URL, :from_items)
    end

    private

    def send_notifications_to(url, scope)
      client = Discordrb::Webhooks::Client.new(url: url)
      DiscordNotification
        .pending
        .send(scope)
        .order(:title)
        .find_in_batches(batch_size: 10) do |notifications|
        builder = build_builder(notifications)
        client.execute(builder, true)
        sleep 3
      rescue => e
        handle_error(e, notifications)
      else
        mark_notifications_as_sent(notifications)
      end
    end

    def build_builder(notifications)
      builder = Discordrb::Webhooks::Builder.new
      builder.content = 'Aqui vão algumas atualizações'
      notifications.each do |notification|
        builder << build_embed(notification)
      end
      builder
    end

    def build_embed(notification)
      embed = Discordrb::Webhooks::Embed.new
      embed.color = rand(1..16777215)
      embed.title = notification.title
      embed.description = notification.description
      embed.url = notification.url
      embed.image = Discordrb::Webhooks::EmbedImage.new(url: notification.image) if notification.image
      embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: notification.thumbnail)
      embed.timestamp = notification.created_at
      notification.fields.each { |f| embed.add_field(**f.symbolize_keys) }
      embed
    end

    def handle_error(e, notifications)
      raise e if Rails.env.development?
      Sentry.capture_exception(e, level: :fatal, extra: { discord_notification_ids: notifications.pluck(:id) })
    end

    def mark_notifications_as_sent(notifications)
      DiscordNotification
        .where(id: notifications.pluck(:id))
        .update_all(sent_at: Time.zone.now)
    end
  end
end
