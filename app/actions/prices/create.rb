module Prices
  class Create < Actor
    input :data_prices, type: Array

    def call
      data_prices.each do |data_price|
        data = PriceDataAdapter.new(data_price).adapt
        next if data[:regular_price].blank?
        price = Price.find_or_initialize_by(nsuid: data[:nsuid])
        price.item = Item.find_by(nsuid: data[:nsuid]) if price.new_record?
        price.assign_attributes(data)
        price.save!
      rescue => e
        Raven.capture_exception(e,
          backtrace: e.backtrace,
          level: :fatal,
          extra: { data: data, price: price }
        )
      end
    end
  end
end
