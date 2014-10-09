RSpec.describe SIX::Instrument do
  let(:client)       { SIX::Client.new(FakeSIX::UI, FakeSIX::PWD) }
  let(:instrument) { client.hiku_data(FakeSIX::LISTING_ID) }

  describe '#history_list' do
    it 'returns a history list' do
      expect(instrument.history_list).to be_a SIX::HistoryList
    end
  end

  describe '#identifier' do
    it 'returns an identifier' do
      expect(instrument.identifier).to eq FakeSIX::LISTING_ID
    end
  end
end
