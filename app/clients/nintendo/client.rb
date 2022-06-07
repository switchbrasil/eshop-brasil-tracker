require 'json'
require 'httparty'

module Nintendo
  class Client
    include HTTParty

    APP_ID = 'U3B6GR4UA3'
    APP_KEY = 'a29c6927638bfd8cee23993e51e721c9'

    attr_reader :app_id, :app_key

    def initialize(app_id: APP_ID, app_key: APP_KEY)
      @app_id = app_id
      @app_key = app_key
    end

    def request(requests:)
      response = self.class.post(api_endpoint, body: JSON.dump({ requests: requests }), headers: headers)
      JSON.parse(response.body)
    end

    private

    def api_endpoint
      @api_url ||= "https://#{app_id.downcase}-dsn.algolia.net/1/indexes/*/queries"
    end

    def headers
      @headers ||= { "x-algolia-application-id" => app_id, "x-algolia-api-key" => app_key }
    end
  end
end
