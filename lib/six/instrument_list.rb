module SIX
  class InstrumentList
    attr_accessor :instruments

    def initialize(instruments_text = nil)
      if instruments_text
        @instruments = instruments_text.map{ |instrument| Instrument.new(instrument) }
      end
    end

    # returns Array of Instrument
    def generate_instruments(valor, currency, exchange_codes)
      @instruments = exchange_codes.map do |market|
        Instrument.new("#{valor},#{market},#{currency}")
      end
    end

    # returns Array of Array. where each Array contains [ik_index: instrument_id]
    def price_request_params
      @instruments.map.with_index { |instrument, index| ["ik#{index+1}", instrument.value] }.to_h
    end
  end
end
