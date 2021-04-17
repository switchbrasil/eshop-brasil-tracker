class NintendoAlgoliaClient
  APPLICATION_ID = 'U3B6GR4UA3'
  API_KEY = 'c4da8be7fd29f0f5bfa42920b0a99dc7'

  def initialize
    @client = Algolia::Client.new(application_id: APPLICATION_ID, api_key: API_KEY)
  end

  def fetch(index:, query:)
    response = index.search(query, queryType: 'prefixAll', hitsPerPage: 500, filters: 'platform:"Nintendo Switch"')
    response['hits'].to_a
  end

  def index_asc
    @index_desc ||= @client.init_index('ncom_game_pt_br_title_asc')
  end

  def index_desc
    @index_desc ||= @client.init_index('ncom_game_pt_br_title_des')
  end
end
