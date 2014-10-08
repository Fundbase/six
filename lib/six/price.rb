module SIX
  class Price
    attr_accessor :data
    # Table 752.
    NONE       = 'none'
    AVAILABLE  = 'avail'
    LAST_PRICE = '3,1'

    def initialize(data)
      @data = data
    end

    def value
      data['v']
    end

    def type
      data['k']
    end
  end
end
