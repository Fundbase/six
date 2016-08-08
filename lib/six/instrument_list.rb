module SIX
  class InstrumentList
    attr_accessor :instruments

    def initialize(instruments = nil)
      @instruments = instruments.map { |instrument| Instrument.new(instrument) } if instruments
    end

    # returns Array of Instrument
    def generate_instruments(valor, currency, exchange_codes)
      @instruments = exchange_codes.map do |market|
        Instrument.new("#{valor},#{market},#{currency}")
      end
    end

    # returns Array of Array. where each Array contains [ik_index: instrument_id]
    def price_request_params
      @instruments.each.with_object({}).with_index do |(instrument, result), index|
        result["ik#{index+1}"] = sanitize_identifier(instrument.value)
      end
    end

    private

    def sanitize_identifier(identifier)
      identifier.gsub(/[^\d,]/, '')
    end
  end
end
