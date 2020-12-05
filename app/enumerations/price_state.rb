class PriceState < EnumerateIt::Base
  associate_values(
    :pre_order,
    :on_sale,
    :unavailable,
    :unreleased
  )
end
