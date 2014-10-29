module SIX
  class Price
    attr_accessor :data, :instrument_identifier

    def initialize(data, instrument_identifier)
      @data = data
      @instrument_identifier = instrument_identifier
    end

    def value
      data.fetch('v', nil)
    end

    def date
      data.fetch('d', nil)
    end
  end
end
