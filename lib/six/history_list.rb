module SIX
  HistoryList = Struct.new(:data) do
    def history_event
      HistoryEvent.new(data['HE'])
    end

    # @return [Array<SIX::HistoryData>]
    def history_data
      Array.wrap(data['HD']).map { |hd| HistoryData.new(hd)}
    end

    def has_history_data?
      data.try(:has_key?, 'HD')
    end
  end
end
