module SIX
  class PriceList
    attr_accessor :prices

    def initialize(data)
      @prices = Array.wrap(data).map do |item|
        if item['P'].class == Array
          prices = []
          item['P'].each do |price|
            price_parsed = Price.new(price, item['k'])
            prices << price_parsed if price_parsed.value
          end
          prices
        else
          Price.new(item['P'], item['k'])
        end

      end
    end

    # returns Price object
    def most_updated
      uptodate_price = @prices.max_by{ |price| price.date.to_i }
    end
  end
end
