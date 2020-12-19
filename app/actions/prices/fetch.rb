module Prices
  class Fetch < Actor
    input :client, type: NintendoPricesClient, default: -> { NintendoPricesClient.new }

    output :data_prices, type: Array

    def call
      data_prices = []
      Item.with_nsuid.find_in_batches(batch_size: 99) do |batch|
        data_prices += client.fetch(country: 'BR', lang: 'pt', nsuids: batch.pluck(:nsuid))
      end
      self.data_prices = data_prices
    end
  end
end
