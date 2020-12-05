class PriceDataAdapter
  def initialize(data)
    @data = data
  end

  def adapt
    {
      nsuid: nsuid,
      regular_price: regular_price,
      discount_price: discount_price,
      discount_start_date: discount_start_date,
      discount_end_date: discount_end_date,
      discount_percentage: discount_percentage,
      state: state,
      data: { golden_points: golden_points }
    }
  end

  def nsuid
    @data['id']
  end

  def regular_price
    return if regular_price_data.nil?

    @regular_price ||= Monetize.parse(regular_price_data.values_at('raw_value', 'currency'))
  end

  def discount_price
    return if discount_price_data.nil?

    @discount_price ||= Monetize.parse(discount_price_data.values_at('raw_value', 'currency'))
  end

  def discount_start_date
    return if discount_price_data.nil?

    Time.zone.parse(discount_price_data['start_datetime'])
  end

  def discount_end_date
    return if discount_price_data.nil?

    Time.zone.parse(discount_price_data['end_datetime'])
  end

  def discount_percentage
    return if discount_price_data.nil?

    ((1 - (discount_price.cents.to_f / regular_price.cents.to_f)) * 100).round
  end

  def state
    case @data['sales_status']
    when 'not_found', 'not_sale', 'sales_termination'
      PriceState::UNAVAILABLE
    when 'onsale'
      PriceState::ON_SALE
    when 'pre_order', 'preorder'
      PriceState::PRE_ORDER
    when 'unreleased'
      PriceState::UNRELEASED
    else
      raise "#{@data['sales_status']} NOT MAPPED PRICE STATE"
    end
  end

  def golden_points
    @data.dig('price', 'gold_point', 'gift_gp')
  end

  private

  def regular_price_data
    @regular_price_data ||= @data.dig('price', 'regular_price')
  end

  def discount_price_data
    @discount_price_data ||= @data.dig('price', 'discount_price')
  end
end
