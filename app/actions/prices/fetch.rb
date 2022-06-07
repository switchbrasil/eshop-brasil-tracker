module Prices
  class Fetch < Actor
    input :client, type: NintendoPricesClient, default: -> { NintendoPricesClient.new }

    output :data_prices, type: Array

    def call
      data_prices = []
      Item.with_nsuid.find_in_batches(batch_size: 99) do |batch|
        nsuids = batch.pluck(:nsuid)
        response = client.fetch(country: 'BR', lang: 'pt', nsuids: nsuids)

        if response.is_a? Array
          data_prices += response
        else
          # some NSUID returns a html page titled "The page you requested is not available. - Nintendo"
          # so we need to iterated each nsuid from batch to get price skipping nsuid with error
          puts "[ERROR] NSUID BATCH WITH PROBLEM. RETRYING INDIVIDUALLY..."
          nsuids.each do |nsuid|
            response = client.fetch(country: 'BR', lang: 'pt', nsuids: [nsuid])
            if response.is_a? Array
              data_prices += response
            else
              puts "[ERROR] NSUID WITH PRICE ERROR #{nsuid}"
              Sentry.capture_message("NSUID WITH PRICE ERROR", level: :fatal, extra: { nsuid: nsuid })
            end
          end
        end
      end
      self.data_prices = data_prices
    rescue => e
      Sentry.capture_exception(e)
    end
  end
end
