class Price < ApplicationRecord
  belongs_to :item

  has_many :change_records, class_name: 'PriceChangeRecord', dependent: :destroy
  has_many :discord_notifications, as: :notificable, dependent: :destroy

  has_enumeration_for :state, with: PriceState, create_helpers: true, required: true, create_scopes: true

  monetize :regular_price_cents, numericality: { greater_than_or_equal_to: 0 }
  monetize :discount_price_cents, allow_nil: true, numericality: { greater_than_or_equal_to: 0 }

  after_save :create_price_change_record
  after_save :create_discord_notification

  def current_price
    discount_price || regular_price
  end

  private

  def create_price_change_record
    return unless current_price_changed?

    change_record = change_records.find_or_initialize_by(reference_date: Time.zone.today)
    change_record.value = current_price
    change_record.save
  end

  def create_discord_notification
    return unless current_price_changed?

    discord_notification = discord_notifications.new(discord_notification_attributes)

    if saved_change_to_discount_price_cents?
      if discount_price.nil?
        discord_notification.description = '😭 Promoção encerrada.'
      else
        discord_notification.fields += [
          { name: 'Preço sem desconto', value: regular_price.format },
          { name: 'Desconto', value: "#{discount_percentage}% OFF" },
          { name: 'Inicia em', value: I18n.l(discount_start_date), inline: true },
          { name: 'Vai até', value: I18n.l(discount_end_date), inline: true }
        ]
        if saved_change_to_id?
          discord_notification.description = '🔥🤑 Preço revelado e com desconto!!!'
        else
          discord_notification.description = '🤑 Jogo em promoção!!!'
        end
      end
    elsif saved_change_to_regular_price_cents?
      if saved_change_to_id?
        discord_notification.description = '🔥 Preço revelado!!!'
      else
        discord_notification.description = '🔧 Reajuste de preço'
        old_price = Money.new(saved_change_to_regular_price_cents.first.to_i, current_price.currency.iso_code)
        discord_notification.fields += [
          { name: 'Preço antes do reajuste', value: old_price.format }
        ]
      end
    end

    discord_notification.save!
  end

  def current_price_changed?
    saved_change_to_regular_price_cents? || saved_change_to_discount_price_cents?
  end

  def discord_notification_attributes
    {
      title: item.title,
      url: item.website_url,
      thumbnail: item.main_picture_url,
      image: item.banner_picture_url,
      fields: [
        { name: 'Preço Atual', value: current_price.format }
      ]
    }
  end
end
