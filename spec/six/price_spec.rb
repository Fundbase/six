RSpec.describe SIX::HistoryData do
  let(:client)       { SIX::Client.new(FakeSIX::UI, FakeSIX::PWD) }
  let(:history_data) { client.hiku_data(FakeSIX::LISTING_ID).history_list.history_data.first }

  describe '#prices' do
    it 'has many prices' do
      expect(history_data.prices).to be_an Array
    end

    it 'contains only prices' do
      expect(history_data.prices.map(&:class).uniq).to eq [SIX::Price]
    end
  end

  describe '#last_price' do
    it 'returns the last price for a day' do
      expect(history_data.last_price.type).to eq SIX::Price::LAST_PRICE
    end
  end

  describe '#date' do
    it 'is a date' do
      expect(history_data.date).to be_a Date
    end
  end
end
