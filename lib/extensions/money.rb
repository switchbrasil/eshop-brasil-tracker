module Extensions
  module Money
    def format_brl
      "#{symbol} #{format(symbol: false)}"
    end
  end
end
