class AlgoliaDataAdapter
  def initialize(data)
    @data = data
  end

  def adapt
    {
      external_id: external_id,
      title: title,
      description: description,
      release_date: release_date,
      release_date_display: release_date_display,
      website_url: website_url,
      main_picture_url: main_picture_url,
      banner_picture_url: banner_picture_url,
      screenshot_url: screenshot_url,
      nsuid: nsuid,
      genres: genres,
      franchises: franchises,
      developers: developers,
      publishers: publishers,
      extra: extra
    }
  end

  private

  def title
    @data['title'].try(:tr, '®™', '')
  end

  def description
    @data['description']
  end

  def release_date
    @data['releaseDateDisplay'].to_date
  rescue
    Date.parse('31/12/2049')
  end

  def release_date_display
    @data['releaseDateDisplay'].to_date
  rescue StandardError
    @data['releaseDateDisplay'] || 'TBD'
  end

  def website_url
    "https://www.nintendo.com#{@data['url']}"
  end

  def main_picture_url
    "https://www.nintendo.com#{@data['boxart']}"
  end

  def banner_picture_url
    "https://www.nintendo.com#{@data['horizontalHeaderImage']}" if @data['horizontalHeaderImage']
  end

  def screenshot_url
    "https://www.nintendo.com#{@data['screenshot']}" if @data['screenshot']
  end

  def external_id
    @data['objectID']
  end

  def nsuid
    @data['nsuid']
  end

  def genres
    @data['genres'].to_a.compact
  end

  def developers
    @data['developers'].to_a.compact
  end

  def publishers
    @data['publishers'].to_a.compact
  end

  def franchises
    @data['franchises'].to_a.compact
  end

  def extra
    {
      free_to_start: @data['freeToStart'],
      demo_available: @data['generalFilters'].to_a.include?('Demo available'),
      has_addon_content: @data['generalFilters'].to_a.include?('DLC available'),
      num_of_players_text: @data['numOfPlayers'],
      paid_subscription_required: @data['generalFilters'].to_a.include?('Online Play via Nintendo Switch Online'),
      physical_version: @data['filterShops'].to_a.include?('At retail'),
      voucher_redeemable: @data['generalFilters'].to_a.include?('Nintendo Switch Game Voucher')
    }.delete_if { |_, v| v.blank? && v.class != FalseClass }
  end
end
