RSpec.describe SIX::HistoryList do
  let(:client)       { SIX::Client.new(FakeSIX::UI, FakeSIX::PWD) }
  let(:history_list) { client.hiku_data(FakeSIX::LISTING_ID).history_list }

  describe '#history_event' do
    it 'returns a history event' do
      expect(history_list.history_event).to be_a SIX::HistoryEvent
    end
  end

  describe '#history_data' do
    it 'returns an array' do
      expect(history_list.history_data).to be_an Array
    end

    it 'contains history data objects' do
      expect(history_list.history_data.map(&:class).uniq).to eq [SIX::HistoryData]
    end
  end

  describe '#has_history_data?' do
    it 'returns true if history data is present' do
      expect(history_list.history_data?).to be true
    end
  end
end
