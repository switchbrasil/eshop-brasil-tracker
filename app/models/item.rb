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
      title: title,
      url: website_url,
      thumbnail: main_picture_url,
      image: banner_picture_url,
      description: '✨ Novo jogo adicionado',
      fields: [
        { name: 'Data de lançamento', value: release_date_display },
        { name: 'Descrição', value: description }
      ]
    )
  end
end
