class RawItem < ApplicationRecord
  belongs_to :item, optional: true

  scope :pending, -> { where(imported: false) }
end
