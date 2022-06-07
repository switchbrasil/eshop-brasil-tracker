module Nintendo
  class RequestsBuilder
    TOKENS = (('a'..'z').to_a + ('0'..'9').to_a).freeze
    INDEXES = %w[
      store_game_pt_br
      store_game_pt_br_release_des
      store_game_pt_br_title_asc
      store_game_pt_br_title_des
      store_game_pt_br_price_asc
      store_game_pt_br_price_des
    ].freeze

    def build(items_per_page: 1000, max_pages: 1)
      requests = []

      INDEXES.each do |index|
        TOKENS.each do |token|
          (0...max_pages).each do |page|
            requests << build_request(
              index: index,
              token: token,
              page: page,
              items_per_page: items_per_page
            )
          end
        end
      end

      requests
    end

    private

    def build_request(index:, token:, page:, items_per_page:)
      {
        indexName: index,
        query: token,
        page: page,
        hitsPerPage: items_per_page,
        facetFilters: ["corePlatforms:Nintendo Switch"]
      }
    end
  end
end
