class Item < ApplicationRecord
  include Sluggable

  has_one :raw_item, dependent: :destroy
  has_one :price, dependent: :destroy
  has_many :price_change_records, through: :price, source: :change_records

  scope :with_nsuid, -> { where.not(nsuid: nil) }
end
