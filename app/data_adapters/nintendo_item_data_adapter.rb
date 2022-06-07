# frozen_string_literal: true

class NintendoItemDataAdapter
  attr_reader :data

  IMAGE_BASE_URL = "https://assets.nintendo.com/image/upload/ar_16:9,b_auto:border,c_lpad/b_white/f_auto/q_auto/dpr_auto/c_scale,w_720/v1"
  ATTRIBUTES = %i[
    item_type title description external_id release_date release_date_display website_url banner_picture_url
    nsuid genres franchises developer publisher
  ].freeze

  def initialize(data)
    @data = data
  end

  def self.adapt(data)
    new(data).adapt
  end

  def adapt
    ATTRIBUTES.index_with { |attribute| send(attribute) }
  end

  private

  def item_type
    case data['dlcType']
    when nil
      "Game"
    when "Individual"
      "DLC"
    when "Bundle"
      "DLC PACK"
    when "ROM Bundle"
      "BUNDLE"
    else
      data['dlcType']
    end
  end

  def title
    data['title'].try(:tr, '®™', '')
  end

  def description
    data['description']
  end

  def release_date
    nil # MUDOU
  end

  def release_date_display
    nil # MUDOU
  end

  def website_url
    url_fixed = data['url']&.gsub("/pt-br/", "/pt-BR/")
    "https://www.nintendo.com#{url_fixed}"
  end

  def banner_picture_url
    "#{IMAGE_BASE_URL}/#{data['productImage']}"
  end

  def external_id
    data['objectID']
  end

  def nsuid
    data['nsuid']
  end

  def genres
    data['genres'].to_a.compact
  end

  def developer
    data['softwareDeveloper']
  end

  def publisher
    data['softwarePublisher']
  end

  def franchises
    data['franchises'].to_a.compact
  end
end
