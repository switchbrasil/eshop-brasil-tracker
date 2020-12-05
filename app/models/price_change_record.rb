class PriceChangeRecord < ApplicationRecord
  belongs_to :price

  monetize :value_cents, numericality: { greater_than_or_equal_to: 0 }
end
