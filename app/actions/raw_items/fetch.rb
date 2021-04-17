module RawItems
  class Fetch < Actor
    input :client, type: NintendoAlgoliaClient, default: -> { NintendoAlgoliaClient.new }

    output :data_items, type: Array

    def call
      all_data = queries.map do |query|
        fetch_data(query: query)
      end

      self.data_items = all_data.flatten.uniq { |d| d['objectID'] }.map { |d| d.except('_highlightResult') }
    end

    private

    def queries
      ('a'..'z').to_a + ('0'..'9').to_a
    end

    def fetch_data(query:)
      data = client.fetch(index: client.index_asc, query: query)
      data += client.fetch(index: client.index_desc, query: query) if data.size >= 500
      data
    end
  end
end
