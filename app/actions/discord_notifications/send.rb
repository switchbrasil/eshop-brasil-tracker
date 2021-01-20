module DiscordNotifications
  class Send < Actor
    def call
      client = Discordrb::Webhooks::Client.new(url: 'https://discord.com/api/webhooks/784085888631308379/0wylP_yojNRPIbfA_zIhYlC5nChasntE_JhONyng11LbnrSvPMdDXh8hEBokPxIl4xfw')
      DiscordNotification.pending.find_in_batches(batch_size: 10) do |notifications_batch|
        builder = Discordrb::Webhooks::Builder.new
        builder.content = 'Aqui vão algumas atualizações'
        notifications_batch.each do |discord_notification|
          embed = Discordrb::Webhooks::Embed.new
          embed.color = rand(1..16777215)
          embed.title = discord_notification.title
          embed.description = discord_notification.description
          embed.url = discord_notification.url
          embed.image = Discordrb::Webhooks::EmbedImage.new(url: discord_notification.image) if discord_notification.image
          embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: discord_notification.thumbnail)
          embed.timestamp = discord_notification.created_at
          discord_notification.fields.each { |f| embed.add_field(f.symbolize_keys) }
          builder << embed
        end
        client.execute(builder, true)
        sleep 3
      rescue => e
        Raven.capture_exception(e,
          backtrace: e.backtrace,
          level: :fatal,
          extra: { discord_notification_ids: notifications_batch.map(&:id) }
        )
      else
        DiscordNotification.where(id: notifications_batch.map(&:id)).update_all(sent_at: Time.zone.now)
      end
    end
  end
end
