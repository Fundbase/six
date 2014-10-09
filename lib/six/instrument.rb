module SIX
  Instrument = Struct.new(:data) do
    include Errorable

    def history_list
      HistoryList.new(data['HL'])
    end

    def identifier
      data['k']
    end

    private

    def errorable_object
      data
    end
  end
end
