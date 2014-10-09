module SIX
  HistoryData = Struct.new(:data) do
    def prices
      Array.wrap(data['P']).map { |p| Price.new(p) }
    end

    def last_price
      prices.find { |price| price.type == Price::LAST_PRICE }
    end

    def date
      data['d'].to_date
    end
  end
end
