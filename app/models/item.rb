class Item < ApplicationRecord
  include Sluggable

  has_one :raw_item, dependent: :destroy
  has_one :price, dependent: :destroy
  has_many :price_change_records, through: :price, source: :change_records
  has_many :discord_notifications, as: :notificable, dependent: :destroy

  scope :with_nsuid, -> { where.not(nsuid: nil) }

  after_create :create_discord_notification

  def create_discord_notification
    discord_notifications.create(
      title: "[#{item_type}] #{title}",
      url: website_url,
      thumbnail: banner_picture_url,
      image: banner_picture_url,
      description: "✨ Adição de #{item_type}",
      fields: [
        { name: 'Editora', value: publisher.presence || "???" },
        { name: 'Desenvolvedora', value: developer.presence || "???" }
      ]
    )
  end
end
