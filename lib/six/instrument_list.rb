module SIX
  InstrumentList = Struct.new(:data) do
    def instruments
      Array.wrap(data['I']).map { |i| Instrument.new(i)}
    end
  end
end
