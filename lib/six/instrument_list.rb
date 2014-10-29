module SIX
  class InstrumentList
    attr_accessor :instruments

    def initialize(valor, currency, exchange_codes)
      @instruments = exchange_codes.map do |market|
        Instrument.new("#{valor},#{market},#{currency}")
      end
    end

    def price_request_params
      @instruments.map.with_index { |instrument, index| ["ik#{index+1}", instrument.value] }.to_h
    end
  end
end
