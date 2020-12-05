class DiscordNotification < ApplicationRecord
  belongs_to :notificable, polymorphic: true

  scope :pending, -> { where(sent_at: nil) }
end
