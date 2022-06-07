# frozen_string_literal: true

module RawItems
  class Fetch < Actor
    input :client, type: Nintendo::Client, default: -> { Nintendo::Client.new }
    input :requests_builder, type: Nintendo::RequestsBuilder, default: -> { Nintendo::RequestsBuilder.new }

    output :data_items, type: Array

    def call
      items_hash = {}

      execute_requests_in_batches do |hits|
        hits.each do |hit|
          items_hash[hit["objectID"]] = hit.except!('createdAt', 'updatedAt')
        end
      end

      self.data_items = items_hash.values
    end

    private

    def execute_requests_in_batches
      all_requests = requests_builder.build
      all_requests.each_slice(20) do |requests|
        response = client.request(requests: requests)
        results = response["results"]
        hits = results.map { |r| r["hits"] }.flatten
        yield hits
      end
    end
  end
end
