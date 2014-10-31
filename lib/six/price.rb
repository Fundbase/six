module SIX
  class Price
    attr_accessor :data, :instrument_identifier

    def initialize(data, instrument_identifier)
      @data = data
      @instrument_identifier = instrument_identifier
    end

    def value
      data['v']
    end

    def date
      data['d']
    end
  end
end
