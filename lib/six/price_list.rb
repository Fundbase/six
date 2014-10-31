module SIX
  class PriceList
    attr_accessor :prices

    def initialize(data)
      @prices = Array.wrap(data).map{ |item| Price.new(item['P'], item['k']) }
    end

    # returns Price object
    def most_updated
      uptodate_price = @prices.max_by{ |price| price.date.to_i }
    end
  end
end
