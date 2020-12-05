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
    if saved_change_to_id && saved_change_to_id.first.nil? || (current_price_changed? && has_price_drop?)
      discord_notification = discord_notifications.new(
        title: item.title,
        url: item.website_url,
        thumbnail: item.main_picture_url,
        fields: [{ name: 'Preço Atual', value: current_price.format }]
      )
      if discount_price.present?
        description = saved_change_to_id? ? '🔥🤑 Preço revelado e com desconto!!!' : '🤑 Jogo em promoção!!!'
        discord_notification.description = description
        discord_notification.fields += [
          { name: 'Preço sem desconto', value: regular_price.format },
          { name: 'Desconto', value: "#{discount_percentage}% OFF" },
          { name: 'Inicia em', value: I18n.l(discount_start_date), inline: true },
          { name: 'Vai até', value: I18n.l(discount_end_date), inline: true }
        ]
      else
        discord_notification.description = '🔥 Preço revelado!!!'
      end
      discord_notification.save!
    end
  end

  def current_price_changed?
    saved_change_to_regular_price_cents? || saved_change_to_discount_price_cents?
  end

  def has_price_drop?
    if saved_change_to_discount_price_cents?
      saved_change_to_discount_price_cents.second.to_i < saved_change_to_discount_price_cents.first.to_i
    elsif saved_change_to_regular_price_cents?
      saved_change_to_regular_price_cents.second.to_i < saved_change_to_regular_price_cents.first.to_i
    end
  end
end
