class DiscordNotification < ApplicationRecord
  belongs_to :notificable, polymorphic: true

  scope :pending, -> { where(sent_at: nil) }
  scope :from_prices, -> { where(notificable_type: 'Price') }
  scope :from_items, -> { where(notificable_type: 'Item') }
end
